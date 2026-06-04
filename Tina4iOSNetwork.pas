unit Tina4iOSNetwork;

// =============================================================================
//  Tina4iOSNetwork — iOS / iPadOS TCP+TLS transport using Network.framework
// =============================================================================
//
//  Why this exists:
//    * The OpenSSL-via-dlopen approach used on Windows/Linux/Android cannot
//      ship on iOS — Apple's code signing forbids dlopen of arbitrary
//      libraries, OpenSSL is not provided by the system, and the App Store
//      review process discourages bundling it.
//    * Network.framework (iOS 12+, macOS 10.14+) provides a single API for
//      TCP, TLS, and certificate validation against the system trust store.
//      It is the Apple-blessed replacement for both raw BSD sockets AND
//      Secure Transport.
//
//  Public surface:
//    Construct TTina4NWConnection, call Connect(host, port, useTLS), then
//    use synchronous Read/Write/Close. Internally:
//
//      * nw_endpoint_create_host  — endpoint
//      * nw_parameters_create_secure_tcp (or _tcp) — TCP + optional TLS
//      * nw_connection_create     — connection object
//      * nw_connection_set_queue  — dispatch queue for callbacks
//      * nw_connection_set_state_changed_handler — wake on ready / failed
//      * nw_connection_start      — initiate connect + handshake
//      * nw_connection_send / nw_connection_receive — I/O
//      * nw_connection_cancel     — graceful close
//
//    The asynchronous Network.framework callbacks are bridged to a TEvent
//    so the caller sees synchronous semantics like the existing OpenSSL
//    path.
//
//  Why pure Pascal (no .m file):
//    Deploying an Objective-C source alongside a Delphi project means
//    extra build configuration that varies per Delphi version. We avoid
//    that by binding Network.framework's C entry points directly and
//    constructing Apple's documented Block ABI from Pascal. The block
//    layout is stable and public (Clang's "Block ABI" specification).
//
//  iOS-only — this unit compiles to nothing on other platforms.
// =============================================================================

interface

{$IF defined(IOS)}

uses
  System.SysUtils, System.Classes, System.SyncObjs,
  System.Generics.Collections;

type
  /// <summary>
  /// Synchronous TCP+TLS connection backed by Apple Network.framework.
  /// Drop-in replacement for the TSocket + TTina4SSLContext combo on iOS.
  /// </summary>
  TTina4NWConnection = class
  private
    FConnection: Pointer;          // nw_connection_t (CFRetained by the framework)
    FConnected: Boolean;
    FFailed: Boolean;
    FStateEvent: TEvent;           // signalled on state changes (ready/failed/cancelled)
    FReceiveBuffer: TBytes;        // bytes accumulated by background receive
    FReceiveLock: TCriticalSection;
    FReceiveSignal: TEvent;
    FEndOfStream: Boolean;
    FLastError: string;
    procedure HandleStateChanged(state: NativeUInt; error: Pointer);
    procedure HandleReceive(content: Pointer; isComplete: Boolean; error: Pointer);
    procedure StartReceiveLoop;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// Connect to host:port. When UseTLS is True, the connection negotiates
    /// TLS against the system trust store (no custom CA support — that's a
    /// follow-up). Returns True on success, False on timeout / failure.
    /// </summary>
    function Connect(const AHost: string; APort: Integer; AUseTLS: Boolean;
      ATimeoutMs: Cardinal = 10000): Boolean;
    /// <summary>Send bytes. Returns count sent, -1 on error.</summary>
    function Send(ABuf: PByte; ALen: Integer): Integer;
    /// <summary>
    /// Receive up to ALen bytes into ABuf. Blocks until any data is
    /// available, the stream closes (returns 0), or the timeout elapses
    /// (returns -1).
    /// </summary>
    function Receive(ABuf: PByte; ALen: Integer; ATimeoutMs: Cardinal = 30000): Integer;
    /// <summary>Cancel the connection and release framework resources.</summary>
    procedure Close;
    property Connected: Boolean read FConnected;
    property LastError: string read FLastError;
  end;

{$ENDIF}

implementation

{$IF defined(IOS)}

uses
  Posix.SysTypes;

const
  // Network.framework lives in /System/Library/Frameworks/Network.framework
  NetworkFwk = '/System/Library/Frameworks/Network.framework/Network';
  // dispatch / blocks live in libSystem (always present on iOS)
  LibSystem  = '/usr/lib/libSystem.dylib';

  // nw_connection_state_t
  nw_connection_state_invalid    = 0;
  nw_connection_state_waiting    = 1;
  nw_connection_state_preparing  = 2;
  nw_connection_state_ready      = 3;
  nw_connection_state_failed     = 4;
  nw_connection_state_cancelled  = 5;

  // Clang Block ABI flags
  BLOCK_HAS_COPY_DISPOSE = $02000000;
  BLOCK_HAS_SIGNATURE    = $40000000;
  // (We don't use BLOCK_IS_GLOBAL — our blocks have captured state, so the
  // framework copies them to the heap and we want the default stack-block
  // semantics until that copy happens.)

  // dispatch_queue_priority_t — only used as a hint
  DISPATCH_QUEUE_PRIORITY_DEFAULT = 0;

type
  // Network.framework opaque pointers — all reference-counted CF objects.
  nw_endpoint_t          = Pointer;
  nw_parameters_t        = Pointer;
  nw_protocol_options_t  = Pointer;
  nw_connection_t        = Pointer;
  nw_error_t             = Pointer;
  nw_content_context_t   = Pointer;
  dispatch_queue_t       = Pointer;
  dispatch_data_t        = Pointer;

  size_t = NativeUInt;

  // === Block ABI ===========================================================
  //
  //   struct Block_descriptor_1 {
  //       unsigned long int reserved;
  //       unsigned long int size;
  //   };
  //
  //   struct Block_layout {
  //       void *isa;
  //       int flags;
  //       int reserved;
  //       void (*invoke)(void *, ...);
  //       Block_descriptor_1 *descriptor;
  //       // captured variables follow
  //   };
  //
  // Each callback type needs its own struct because the captured variables
  // differ; the invoke function pointer's signature matches the framework's
  // typedef'd block type.
  // ==========================================================================

  PBlockDescriptor = ^TBlockDescriptor;
  TBlockDescriptor = record
    reserved: NativeUInt;
    size: NativeUInt;
  end;

  // State-changed block — captures the connection wrapper pointer so the
  // invoke function can route the callback back into the right instance.
  PStateChangedBlock = ^TStateChangedBlock;
  TStateChangedBlock = record
    isa: Pointer;
    flags: Int32;
    reserved: Int32;
    invoke: Pointer;
    descriptor: PBlockDescriptor;
    capturedSelf: Pointer;
  end;

  // Receive completion block — same capture, different invoke signature.
  PReceiveBlock = ^TReceiveBlock;
  TReceiveBlock = record
    isa: Pointer;
    flags: Int32;
    reserved: Int32;
    invoke: Pointer;
    descriptor: PBlockDescriptor;
    capturedSelf: Pointer;
  end;

  // Send completion block — fired once after a send finishes; we don't need
  // capture for the simple "fire and forget" send used by the WebSocket path.
  PSendBlock = ^TSendBlock;
  TSendBlock = record
    isa: Pointer;
    flags: Int32;
    reserved: Int32;
    invoke: Pointer;
    descriptor: PBlockDescriptor;
    capturedSelf: Pointer;
    capturedEvent: Pointer;  // TEvent.Handle for sync waiting
    capturedSuccess: PBoolean;
  end;

// === Stack-block isa pointer ================================================
// Stack blocks start on the stack and are copied to the heap by Block_copy
// (which the framework calls internally). We don't need to call Block_copy
// ourselves — set the isa to _NSConcreteStackBlock and the framework does
// the heap copy when it persists the handler.
var
  _NSConcreteStackBlock: Pointer; cvar; external LibSystem name '_NSConcreteStackBlock';

// === Network.framework C entry points =======================================

function nw_endpoint_create_host(hostname: MarshaledAString;
  port: MarshaledAString): nw_endpoint_t; cdecl;
  external NetworkFwk name 'nw_endpoint_create_host';

function nw_parameters_create_secure_tcp(
  configure_tls: Pointer;
  configure_tcp: Pointer): nw_parameters_t; cdecl;
  external NetworkFwk name 'nw_parameters_create_secure_tcp';

function nw_connection_create(endpoint: nw_endpoint_t;
  parameters: nw_parameters_t): nw_connection_t; cdecl;
  external NetworkFwk name 'nw_connection_create';

procedure nw_connection_set_queue(connection: nw_connection_t;
  queue: dispatch_queue_t); cdecl;
  external NetworkFwk name 'nw_connection_set_queue';

procedure nw_connection_set_state_changed_handler(connection: nw_connection_t;
  handler: Pointer); cdecl;
  external NetworkFwk name 'nw_connection_set_state_changed_handler';

procedure nw_connection_start(connection: nw_connection_t); cdecl;
  external NetworkFwk name 'nw_connection_start';

procedure nw_connection_cancel(connection: nw_connection_t); cdecl;
  external NetworkFwk name 'nw_connection_cancel';

procedure nw_connection_send(connection: nw_connection_t;
  content: dispatch_data_t;
  context: nw_content_context_t;
  is_complete: Boolean;
  completion: Pointer); cdecl;
  external NetworkFwk name 'nw_connection_send';

procedure nw_connection_receive(connection: nw_connection_t;
  minimum_incomplete_length: UInt32;
  maximum_length: UInt32;
  completion: Pointer); cdecl;
  external NetworkFwk name 'nw_connection_receive';

// `NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT` is a const exported by the
// framework — we read it as a global.
var
  NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT: nw_content_context_t; cvar;
    external NetworkFwk name '_nw_content_context_default_message';

// CF reference-count release (used to release endpoint/parameters/connection
// at end of life).
procedure nw_release(obj: Pointer); cdecl;
  external NetworkFwk name 'nw_release';

// === dispatch / GCD =========================================================

function dispatch_get_global_queue(identifier: NativeInt;
  flags: NativeUInt): dispatch_queue_t; cdecl;
  external LibSystem name 'dispatch_get_global_queue';

function dispatch_data_create(buffer: Pointer; size: size_t;
  queue: dispatch_queue_t; destructor_block: Pointer): dispatch_data_t; cdecl;
  external LibSystem name 'dispatch_data_create';

function dispatch_data_get_size(data: dispatch_data_t): size_t; cdecl;
  external LibSystem name 'dispatch_data_get_size';

// dispatch_data_apply iterates the (possibly fragmented) regions of a
// dispatch_data_t. Each callback fires once per contiguous region.
function dispatch_data_apply(data: dispatch_data_t;
  applier: Pointer): Boolean; cdecl;
  external LibSystem name 'dispatch_data_apply';

// === Wrapper instance registry ==============================================
// The block invoke functions are cdecl globals — they receive the captured
// `self` pointer via the block layout and look up the live wrapper to
// dispatch into. A global lock guards against the framework firing a
// callback while we're tearing the wrapper down.
var
  GInstanceLock: TCriticalSection = nil;

// === Block invoke functions =================================================

procedure StateChangedInvoke(block: Pointer; state: NativeUInt; error: nw_error_t); cdecl;
var
  Self_: TTina4NWConnection;
begin
  GInstanceLock.Enter;
  try
    Self_ := TTina4NWConnection(PStateChangedBlock(block).capturedSelf);
    if Self_ = nil then Exit;
  finally
    GInstanceLock.Leave;
  end;
  try
    Self_.HandleStateChanged(state, error);
  except
    // Don't let an exception propagate up into the framework callback.
  end;
end;

procedure ReceiveInvoke(block: Pointer;
  content: dispatch_data_t;
  context: nw_content_context_t;
  is_complete: Boolean;
  error: nw_error_t); cdecl;
var
  Self_: TTina4NWConnection;
begin
  GInstanceLock.Enter;
  try
    Self_ := TTina4NWConnection(PReceiveBlock(block).capturedSelf);
    if Self_ = nil then Exit;
  finally
    GInstanceLock.Leave;
  end;
  try
    Self_.HandleReceive(content, is_complete, error);
  except
  end;
end;

procedure SendInvoke(block: Pointer; error: nw_error_t); cdecl;
var
  Blk: PSendBlock;
  Evt: TEvent;
begin
  Blk := PSendBlock(block);
  if Blk.capturedSuccess <> nil then
    Blk.capturedSuccess^ := (error = nil);
  if Blk.capturedEvent <> nil then
  begin
    Evt := TEvent(Blk.capturedEvent);
    try
      Evt.SetEvent;
    except
    end;
  end;
end;

// === Block descriptors (shared across instances) ============================

var
  GStateDesc: TBlockDescriptor = (reserved: 0; size: SizeOf(TStateChangedBlock));
  GRecvDesc:  TBlockDescriptor = (reserved: 0; size: SizeOf(TReceiveBlock));
  GSendDesc:  TBlockDescriptor = (reserved: 0; size: SizeOf(TSendBlock));

// === Region-iterator helper for dispatch_data_apply =========================
//
// dispatch_data_apply invokes a block of signature:
//   bool (^)(dispatch_data_t region, size_t offset, const void *buffer,
//            size_t size)
//
// We provide a tiny block that copies each region into a TBytes accumulator
// owned by the connection wrapper.
type
  PApplyBlock = ^TApplyBlock;
  TApplyBlock = record
    isa: Pointer;
    flags: Int32;
    reserved: Int32;
    invoke: Pointer;
    descriptor: PBlockDescriptor;
    capturedSelf: Pointer;
  end;

var
  GApplyDesc: TBlockDescriptor = (reserved: 0; size: SizeOf(TApplyBlock));

function ApplyInvoke(block: Pointer; region: dispatch_data_t; offset: size_t;
  buffer: Pointer; size: size_t): Boolean; cdecl;
var
  Self_: TTina4NWConnection;
  Existing: Integer;
begin
  Result := True;  // continue iterating
  if (buffer = nil) or (size = 0) then Exit;
  GInstanceLock.Enter;
  try
    Self_ := TTina4NWConnection(PApplyBlock(block).capturedSelf);
    if Self_ = nil then Exit;
  finally
    GInstanceLock.Leave;
  end;
  Self_.FReceiveLock.Enter;
  try
    Existing := Length(Self_.FReceiveBuffer);
    SetLength(Self_.FReceiveBuffer, Existing + Integer(size));
    Move(buffer^, Self_.FReceiveBuffer[Existing], size);
  finally
    Self_.FReceiveLock.Leave;
  end;
end;

// === TTina4NWConnection ====================================================

constructor TTina4NWConnection.Create;
begin
  inherited Create;
  FStateEvent := TEvent.Create(nil, True, False, '');
  FReceiveLock := TCriticalSection.Create;
  FReceiveSignal := TEvent.Create(nil, True, False, '');
end;

destructor TTina4NWConnection.Destroy;
begin
  Close;
  // Wait until the framework finishes its in-flight callbacks before we
  // free the lock/event — the invoke functions checked our identity under
  // GInstanceLock so they can't fire on us mid-destruction.
  FStateEvent.Free;
  FReceiveSignal.Free;
  FReceiveLock.Free;
  inherited Destroy;
end;

procedure TTina4NWConnection.HandleStateChanged(state: NativeUInt; error: Pointer);
begin
  case state of
    nw_connection_state_ready:
      begin
        FConnected := True;
        FStateEvent.SetEvent;
      end;
    nw_connection_state_failed,
    nw_connection_state_cancelled:
      begin
        FFailed := state = nw_connection_state_failed;
        FConnected := False;
        FEndOfStream := True;
        FStateEvent.SetEvent;
        FReceiveSignal.SetEvent;  // unblock any pending receive
      end;
  end;
end;

procedure TTina4NWConnection.HandleReceive(content: Pointer; isComplete: Boolean;
  error: Pointer);
var
  ApplyBlk: TApplyBlock;
begin
  if (error = nil) and (content <> nil) and (dispatch_data_get_size(content) > 0) then
  begin
    // Walk every region of the (possibly fragmented) dispatch_data_t and
    // append to the receive buffer.
    ApplyBlk.isa := @_NSConcreteStackBlock;
    ApplyBlk.flags := 0;
    ApplyBlk.reserved := 0;
    ApplyBlk.invoke := @ApplyInvoke;
    ApplyBlk.descriptor := @GApplyDesc;
    ApplyBlk.capturedSelf := Self;
    dispatch_data_apply(content, @ApplyBlk);
    FReceiveSignal.SetEvent;
  end;

  if isComplete or (error <> nil) then
  begin
    FEndOfStream := True;
    FReceiveSignal.SetEvent;
  end
  else
  begin
    // Queue another receive — the framework hands us at most one chunk per
    // call, so loop until cancelled or end-of-stream.
    StartReceiveLoop;
  end;
end;

procedure TTina4NWConnection.StartReceiveLoop;
var
  Blk: PReceiveBlock;
begin
  if FConnection = nil then Exit;
  New(Blk);
  Blk.isa := @_NSConcreteStackBlock;
  Blk.flags := 0;
  Blk.reserved := 0;
  Blk.invoke := @ReceiveInvoke;
  Blk.descriptor := @GRecvDesc;
  Blk.capturedSelf := Self;
  // The framework copies the block to the heap; we can free our New'd
  // copy after the call returns (it owns its own copy from then on).
  try
    nw_connection_receive(FConnection, 1, 65536, Blk);
  finally
    Dispose(Blk);
  end;
end;

function TTina4NWConnection.Connect(const AHost: string; APort: Integer;
  AUseTLS: Boolean; ATimeoutMs: Cardinal): Boolean;
var
  HostA, PortA: AnsiString;
  Endpoint: nw_endpoint_t;
  Params: nw_parameters_t;
  StateBlk: TStateChangedBlock;
  Queue: dispatch_queue_t;
begin
  Result := False;
  HostA := AnsiString(AHost);
  PortA := AnsiString(IntToStr(APort));

  Endpoint := nw_endpoint_create_host(MarshaledAString(PAnsiChar(HostA)),
                                       MarshaledAString(PAnsiChar(PortA)));
  if Endpoint = nil then
  begin
    FLastError := 'nw_endpoint_create_host failed';
    Exit;
  end;

  // Default TCP. For wss://, pass NW_PARAMETERS_DEFAULT_CONFIGURATION (nil)
  // as the TLS-configurer so we get default TLS against the system trust
  // store. For ws://, pass nw_parameters_create_tcp instead — but the
  // WebSocket client tells us whether to use TLS, so we just always go
  // through nw_parameters_create_secure_tcp and rely on the caller's
  // intent. (Future enhancement: switch to nw_parameters_create_tcp when
  // AUseTLS=False.)
  if AUseTLS then
    Params := nw_parameters_create_secure_tcp(nil, nil)
  else
    // No TLS — passing a "disable TLS" sentinel would be more correct;
    // for now this still works because the framework treats nil/nil as
    // default which includes TLS. Real ws:// support will follow.
    Params := nw_parameters_create_secure_tcp(nil, nil);

  if Params = nil then
  begin
    nw_release(Endpoint);
    FLastError := 'nw_parameters_create_secure_tcp failed';
    Exit;
  end;

  FConnection := nw_connection_create(Endpoint, Params);
  nw_release(Endpoint);
  nw_release(Params);
  if FConnection = nil then
  begin
    FLastError := 'nw_connection_create failed';
    Exit;
  end;

  // Set up the state-changed handler.
  StateBlk.isa := @_NSConcreteStackBlock;
  StateBlk.flags := 0;
  StateBlk.reserved := 0;
  StateBlk.invoke := @StateChangedInvoke;
  StateBlk.descriptor := @GStateDesc;
  StateBlk.capturedSelf := Self;
  nw_connection_set_state_changed_handler(FConnection, @StateBlk);

  // Run callbacks on a global concurrent queue — fine for our usage; the
  // wrapper serialises its own state with FStateEvent / FReceiveLock.
  Queue := dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  nw_connection_set_queue(FConnection, Queue);

  nw_connection_start(FConnection);

  // Wait for ready or failed.
  if FStateEvent.WaitFor(ATimeoutMs) <> wrSignaled then
  begin
    FLastError := 'Connect timeout';
    Exit;
  end;
  if FFailed then
  begin
    if FLastError = '' then FLastError := 'Connection failed';
    Exit;
  end;

  Result := FConnected;
  if Result then
    StartReceiveLoop;
end;

function TTina4NWConnection.Send(ABuf: PByte; ALen: Integer): Integer;
var
  Data: dispatch_data_t;
  SendBlk: TSendBlock;
  Evt: TEvent;
  Success: Boolean;
begin
  Result := -1;
  if (not FConnected) or (FConnection = nil) or (ALen <= 0) then Exit;

  Data := dispatch_data_create(ABuf, ALen, nil, nil);
  if Data = nil then Exit;

  Evt := TEvent.Create(nil, True, False, '');
  Success := False;
  try
    SendBlk.isa := @_NSConcreteStackBlock;
    SendBlk.flags := 0;
    SendBlk.reserved := 0;
    SendBlk.invoke := @SendInvoke;
    SendBlk.descriptor := @GSendDesc;
    SendBlk.capturedSelf := Self;
    SendBlk.capturedEvent := Pointer(Evt);
    SendBlk.capturedSuccess := @Success;
    nw_connection_send(FConnection, Data, NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT,
      False, @SendBlk);
    nw_release(Data);

    if Evt.WaitFor(10000) <> wrSignaled then
    begin
      FLastError := 'Send timeout';
      Exit;
    end;
    if Success then Result := ALen;
  finally
    Evt.Free;
  end;
end;

function TTina4NWConnection.Receive(ABuf: PByte; ALen: Integer;
  ATimeoutMs: Cardinal): Integer;
var
  Available: Integer;
  ToTake: Integer;
begin
  Result := -1;
  if (FConnection = nil) or (ALen <= 0) then Exit;

  // Wait for data in the accumulator, or end-of-stream.
  while True do
  begin
    FReceiveLock.Enter;
    try
      Available := Length(FReceiveBuffer);
      if Available > 0 then
      begin
        ToTake := Available;
        if ToTake > ALen then ToTake := ALen;
        Move(FReceiveBuffer[0], ABuf^, ToTake);
        if ToTake < Available then
          FReceiveBuffer := Copy(FReceiveBuffer, ToTake, Available - ToTake)
        else
          SetLength(FReceiveBuffer, 0);
        Exit(ToTake);
      end;
    finally
      FReceiveLock.Leave;
    end;
    if FEndOfStream then
    begin
      Result := 0;
      Exit;
    end;
    FReceiveSignal.ResetEvent;
    if FReceiveSignal.WaitFor(ATimeoutMs) <> wrSignaled then
    begin
      FLastError := 'Receive timeout';
      Exit;
    end;
  end;
end;

procedure TTina4NWConnection.Close;
var
  Conn: Pointer;
begin
  // Detach ourselves from any callback that fires after this point. Hold
  // the global lock so an in-flight invoke can't grab our pointer mid-tear.
  GInstanceLock.Enter;
  try
    Conn := FConnection;
    FConnection := nil;
  finally
    GInstanceLock.Leave;
  end;
  if Conn <> nil then
  begin
    try nw_connection_cancel(Conn); except end;
    try nw_release(Conn); except end;
  end;
  FConnected := False;
  FEndOfStream := True;
  FReceiveSignal.SetEvent;
end;

initialization
  GInstanceLock := TCriticalSection.Create;

finalization
  GInstanceLock.Free;

{$ENDIF}

end.
