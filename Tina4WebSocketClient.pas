unit Tina4WebSocketClient;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Net.Socket,
  System.Types, System.NetEncoding, System.Hash, System.DateUtils,
  {$IFDEF POSIX}Posix.NetDB, Posix.SysSocket, Posix.ArpaInet,{$ENDIF}
  Tina4OpenSSL, Tina4WebSocketFrames;

type
  /// <summary>WebSocket connection state</summary>
  TTina4WSState = (wsClosed, wsConnecting, wsOpen, wsClosing, wsReconnecting);

  /// <summary>Text message event</summary>
  TTina4WSMessageEvent = procedure(Sender: TObject;
    const AMessage: string) of object;
  /// <summary>Binary message event</summary>
  TTina4WSBinaryEvent = procedure(Sender: TObject;
    const AData: TBytes) of object;
  /// <summary>Error event</summary>
  TTina4WSErrorEvent = procedure(Sender: TObject;
    const AError: string) of object;
  /// <summary>Disconnect event with close code and reason</summary>
  TTina4WSDisconnectEvent = procedure(Sender: TObject;
    const ACode: Integer; const AReason: string) of object;
  /// <summary>Reconnect attempt event</summary>
  TTina4WSReconnectEvent = procedure(Sender: TObject;
    AAttempt: Integer) of object;
  /// <summary>State-transition event. Fired for every state change after
  /// the new state is in effect.</summary>
  TTina4WSStateChangeEvent = procedure(Sender: TObject;
    AOldState, ANewState: TTina4WSState) of object;

  TTina4WebSocketClient = class;

  /// <summary>Background thread that reads WebSocket frames</summary>
  TTina4WSReadThread = class(TThread)
  private
    FOwner: TTina4WebSocketClient;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TTina4WebSocketClient);
  end;

  /// <summary>
  /// Cross-platform WebSocket client component.
  /// Supports ws:// and wss:// protocols using System.Net.Socket and OpenSSL.
  /// Drop on a form, set URL and headers, call Connect.
  /// </summary>
  [ComponentPlatforms(pidAllPlatforms)]
  TTina4WebSocketClient = class(TComponent)
  private
    FURL: string;
    FHeaders: TStringList;
    FAutoReconnect: Boolean;
    FReconnectInterval: Integer;
    FReconnectMaxInterval: Integer;
    FReconnectMaxAttempts: Integer;
    FPingInterval: Integer;
    FPongTimeout: Integer;
    FMaxConnectionAge: Integer;
    FConnectTimeout: Integer;
    FState: TTina4WSState;
    FStateLock: TCriticalSection;  // serializes FState reads/writes

    FOnConnected: TNotifyEvent;
    FOnDisconnected: TTina4WSDisconnectEvent;
    FOnMessage: TTina4WSMessageEvent;
    FOnBinaryReceived: TTina4WSBinaryEvent;
    FOnError: TTina4WSErrorEvent;
    FOnReconnecting: TTina4WSReconnectEvent;
    FOnStateChange: TTina4WSStateChangeEvent;

    FSocket: TSocket;
    FSSL: TTina4SSLContext;
    {$IFDEF IOS}
    // On iOS, wss:// is handled end-to-end by Apple's Network.framework
    // (TCP + TLS together) — there is no socket fd to wrap with OpenSSL.
    FNWConn: TTina4NWConnection;
    {$ENDIF}
    FUseTLS: Boolean;
    FHost: string;
    FPort: Integer;
    FPath: string;
    FReadThread: TTina4WSReadThread;
    FWriteLock: TCriticalSection;
    FReconnectAttempt: Integer;
    FLastPingSent: TDateTime;
    FLastFrameAt: TDateTime;  // updated on EVERY received frame (watchdog)
    FLastRTT: Integer;        // ms, latest ping-to-pong round-trip
    FConnectedAt: TDateTime;  // when the current connection went wsOpen
    FPingTimer: TThread;
    FPingWake: TEvent;       // signaled to wake ping thread out of its wait early
    FReconnectWake: TEvent;  // signaled to break out of backoff wait
    FReconnectThread: TThread;
    FForceReconnect: Boolean; // ForceReconnect path: bypass MaxAttempts/AutoReconnect

    function GetHeaders: TStrings;
    procedure SetHeaders(const Value: TStrings);
    function GetState: TTina4WSState;
    procedure SetState(ANewState: TTina4WSState);
    function ComputeBackoffMs(AAttempt: Integer): Integer;
    procedure ParseURL;
    procedure DoConnect;
    procedure DoTCPConnect;
    procedure DoTLSHandshake;
    procedure DoWSHandshake;
    procedure DoDisconnectInternal(ACode: Integer; const AReason: string;
      AStartReconnect: Boolean);
    procedure DoReconnect;
    procedure StartPingTimer;
    procedure StopPingTimer;

    // Low-level socket I/O (plain or TLS)
    procedure RawSend(const AData: TBytes);
    function RawRecv(ALen: Integer): TBytes;
    function RawRecvByte: Byte;

    // WebSocket frame encode/decode (delegates to Tina4WebSocketFrames)
    function EncodeFrame(AOpcode: Byte; const APayload: TBytes): TBytes;
    procedure ProcessFrame(AOpcode: Byte; const APayload: TBytes);

    // Event dispatchers (queue to main thread)
    procedure FireConnected;
    procedure FireDisconnected(ACode: Integer; const AReason: string);
    procedure FireMessage(const AMsg: string);
    procedure FireBinary(const AData: TBytes);
    procedure FireError(const AError: string);
    procedure FireReconnecting(AAttempt: Integer);
    procedure FireStateChange(AOldState, ANewState: TTina4WSState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    /// <summary>Connect to the WebSocket server</summary>
    procedure Connect;
    /// <summary>Disconnect gracefully with normal close code (1000).</summary>
    procedure Disconnect; overload;
    /// <summary>Disconnect with an explicit close code and reason. Common
    /// mobile codes: 1000 normal, 1001 going-away (background/logout),
    /// 4000-4999 application-specific.</summary>
    procedure Disconnect(ACode: Integer; const AReason: string); overload;
    /// <summary>Force an immediate reconnect regardless of AutoReconnect or
    /// MaxAttempts. Intended for "app resumed from background / network
    /// changed" scenarios where the current socket may be stale.</summary>
    procedure ForceReconnect;
    /// <summary>Non-destructive liveness probe. Sends an immediate ping and
    /// shortens the watchdog deadline so a dead link fails fast. If the
    /// pong returns within PongTimeout the connection survives untouched.
    /// Call after a network-change notification on mobile.</summary>
    procedure NotifyNetworkChanged;
    /// <summary>Send a text message</summary>
    procedure Send(const AMessage: string); overload;
    /// <summary>Send binary data</summary>
    procedure Send(const AData: TBytes); overload;
    /// <summary>True if the connection is open</summary>
    function IsConnected: Boolean;
    /// <summary>Current connection state (thread-safe).</summary>
    property State: TTina4WSState read GetState;
    /// <summary>Latest ping-to-pong round-trip in milliseconds. 0 until
    /// the first pong arrives. Useful for showing connection quality.</summary>
    property LastRTT: Integer read FLastRTT;
    /// <summary>Wall-clock time the current connection went wsOpen.</summary>
    property ConnectedAt: TDateTime read FConnectedAt;
    /// <summary>Wall-clock time of the most recent received frame (any
    /// opcode — message, ping, pong). The watchdog uses this.</summary>
    property LastFrameAt: TDateTime read FLastFrameAt;
  published
    /// <summary>WebSocket URL (ws:// or wss://)</summary>
    property URL: string read FURL write FURL;
    /// <summary>Custom HTTP headers (one per line, Name: Value format)</summary>
    property Headers: TStrings read GetHeaders write SetHeaders;
    /// <summary>Auto-reconnect on unexpected disconnect (default True)</summary>
    property AutoReconnect: Boolean read FAutoReconnect write FAutoReconnect
      default True;
    /// <summary>Initial delay between reconnect attempts in ms (default 3000).
    /// Subsequent attempts double up to ReconnectMaxInterval with 0-25% jitter
    /// — exponential backoff prevents thundering-herd against a down server.</summary>
    property ReconnectInterval: Integer read FReconnectInterval
      write FReconnectInterval default 3000;
    /// <summary>Cap on the exponential backoff (default 60000 = 60s). The
    /// computed delay is min(ReconnectMaxInterval, ReconnectInterval * 2^(n-1))
    /// plus random jitter.</summary>
    property ReconnectMaxInterval: Integer read FReconnectMaxInterval
      write FReconnectMaxInterval default 60000;
    /// <summary>Max reconnect attempts. 0 = infinite (default 10)</summary>
    property ReconnectMaxAttempts: Integer read FReconnectMaxAttempts
      write FReconnectMaxAttempts default 10;
    /// <summary>Ping interval in ms. 0 = disabled (default 30000)</summary>
    property PingInterval: Integer read FPingInterval write FPingInterval
      default 30000;
    /// <summary>How long after a ping (or any received frame) the watchdog
    /// waits for a frame back before declaring the link dead and forcing a
    /// reconnect. Mobile-critical: detects half-open sockets in seconds
    /// rather than waiting minutes for OS TCP timeout. 0 = disabled.
    /// Default 10000ms.</summary>
    property PongTimeout: Integer read FPongTimeout write FPongTimeout
      default 10000;
    /// <summary>If > 0, the connection is gracefully rotated this many ms
    /// after it goes wsOpen. Defeats silent NAT / middlebox timeouts on
    /// long-lived mobile sockets. 0 = disabled (default).</summary>
    property MaxConnectionAge: Integer read FMaxConnectionAge
      write FMaxConnectionAge default 0;
    /// <summary>TCP connect timeout in ms (default 5000)</summary>
    property ConnectTimeout: Integer read FConnectTimeout write FConnectTimeout
      default 5000;
    /// <summary>Fired when WebSocket connection is established</summary>
    property OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    /// <summary>Fired when disconnected with close code and reason</summary>
    property OnDisconnected: TTina4WSDisconnectEvent read FOnDisconnected
      write FOnDisconnected;
    /// <summary>Fired when a text message is received</summary>
    property OnMessage: TTina4WSMessageEvent read FOnMessage
      write FOnMessage;
    /// <summary>Fired when binary data is received</summary>
    property OnBinaryReceived: TTina4WSBinaryEvent read FOnBinaryReceived
      write FOnBinaryReceived;
    /// <summary>Fired on connection or protocol errors</summary>
    property OnError: TTina4WSErrorEvent read FOnError write FOnError;
    /// <summary>Fired before each reconnect attempt</summary>
    property OnReconnecting: TTina4WSReconnectEvent read FOnReconnecting
      write FOnReconnecting;
    /// <summary>Fired after every state transition. Single hook for UI
    /// connection-quality indicators — covers wsClosed/wsConnecting/wsOpen/
    /// wsClosing/wsReconnecting without chaining the specific events.</summary>
    property OnStateChange: TTina4WSStateChangeEvent read FOnStateChange
      write FOnStateChange;
  end;

procedure Register;

implementation

{$IFDEF MSWINDOWS}
uses
  Winapi.Windows;
{$ENDIF}

var
  UnitFinalized: Boolean = False;

// WebSocket opcodes, FIN/MASK bits and the WS GUID now live in
// Tina4WebSocketFrames so the upcoming server can share them.

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4WebSocketClient]);
end;

{ ---- DNS Resolution ---- }

function ResolveHostName(const AHost: string): string;
{$IFDEF MSWINDOWS}
// Use Winsock2 getaddrinfo for proper DNS resolution on Windows.
// TIPAddress.LookupAddress does not resolve hostnames (returns 255.255.255.255).
// We dynamically call ws2_32.dll to avoid unit-level Winsock2 import conflicts.
type
  TWS2AddrInfo = record
    ai_flags: Integer;
    ai_family: Integer;
    ai_socktype: Integer;
    ai_protocol: Integer;
    ai_addrlen: NativeUInt;
    ai_canonname: PWideChar;
    ai_addr: Pointer;
    ai_next: Pointer;
  end;
  PWS2AddrInfo = ^TWS2AddrInfo;

  TWS2SockAddrIn = packed record
    sin_family: Word;
    sin_port: Word;
    sin_addr: Cardinal;
    sin_zero: array[0..7] of Byte;
  end;
  PWS2SockAddrIn = ^TWS2SockAddrIn;

  TGetAddrInfoW = function(pNodeName, pServiceName: PWideChar;
    const pHints: TWS2AddrInfo; var ppResult: PWS2AddrInfo): Integer; stdcall;
  TFreeAddrInfoW = procedure(pAddrInfo: PWS2AddrInfo); stdcall;

const
  AF_INET = 2;
  SOCK_STREAM = 1;
  IPPROTO_TCP = 6;

var
  Lib: THandle;
  fnGetAddrInfo: TGetAddrInfoW;
  fnFreeAddrInfo: TFreeAddrInfoW;
  Hints: TWS2AddrInfo;
  Res: PWS2AddrInfo;
  Ret: Integer;
  Addr: Cardinal;
begin
  Result := '';

  Lib := GetModuleHandle('ws2_32.dll');
  if Lib = 0 then
    Lib := LoadLibrary('ws2_32.dll');
  if Lib = 0 then
    Exit;

  @fnGetAddrInfo := GetProcAddress(Lib, 'GetAddrInfoW');
  @fnFreeAddrInfo := GetProcAddress(Lib, 'FreeAddrInfoW');
  if not Assigned(fnGetAddrInfo) or not Assigned(fnFreeAddrInfo) then
    Exit;

  FillChar(Hints, SizeOf(TWS2AddrInfo), 0);
  Hints.ai_family := AF_INET;
  Hints.ai_socktype := SOCK_STREAM;
  Hints.ai_protocol := IPPROTO_TCP;

  Res := nil;
  Ret := fnGetAddrInfo(PWideChar(WideString(AHost)), nil, Hints, Res);
  if Ret <> 0 then
    Exit;

  try
    if (Res <> nil) and (Res^.ai_family = AF_INET) then
    begin
      Addr := PWS2SockAddrIn(Res^.ai_addr)^.sin_addr;
      Result := Format('%d.%d.%d.%d', [
        Byte(Addr), Byte(Addr shr 8),
        Byte(Addr shr 16), Byte(Addr shr 24)]);
    end;
  finally
    if Res <> nil then
      fnFreeAddrInfo(Res);
  end;
end;
{$ELSE}
var
  AddrStr: MarshaledAString;
  Hints: Posix.NetDB.addrinfo;
  Res: Paddrinfo;
  Ret: Integer;
  Addr: Cardinal;
  AddrPtr: Pointer;
begin
  Result := '';
  FillChar(Hints, SizeOf(Hints), 0);
  Hints.ai_family := AF_INET;
  Hints.ai_socktype := SOCK_STREAM;
  Res := nil;
  AddrStr := MarshaledAString(UTF8String(AHost));
  Ret := Posix.NetDB.getaddrinfo(AddrStr, nil, Hints, Res);
  if (Ret = 0) and (Res <> nil) then
  begin
    try
      // sin_addr is at offset 4 in sockaddr_in (after sin_family + sin_port)
      AddrPtr := Res^.ai_addr;
      Move(PByte(AddrPtr)[4], Addr, 4);
      Result := Format('%d.%d.%d.%d', [
        Byte(Addr), Byte(Addr shr 8),
        Byte(Addr shr 16), Byte(Addr shr 24)]);
    finally
      Posix.NetDB.freeaddrinfo(Res^);
    end;
  end;
end;
{$ENDIF}

{ ---- TTina4WSReadThread ---- }

constructor TTina4WSReadThread.Create(AOwner: TTina4WebSocketClient);
begin
  inherited Create(True); // create suspended
  FOwner := AOwner;
  FreeOnTerminate := False;
end;

procedure TTina4WSReadThread.Execute;
var
  Frame: TTina4WSFrame;
begin
  // Frame parsing now lives in Tina4WebSocketFrames.ReadFrame so the
  // server unit can share it. We just supply our byte source and
  // dispatch the assembled message to ProcessFrame.
  while not Terminated and (FOwner.GetState = wsOpen) do
  begin
    try
      Frame := ReadFrame(
        function(ALen: Integer): TBytes
        begin
          Result := FOwner.RawRecv(ALen);
        end);
      FOwner.ProcessFrame(Frame.Opcode, Frame.Payload);
    except
      on E: Exception do
      begin
        if not Terminated and (FOwner.GetState = wsOpen) then
        begin
          FOwner.FireError('Read error: ' + E.Message);
          FOwner.DoDisconnectInternal(1006, 'Connection lost', True);
        end;
        Break;
      end;
    end;
  end;
end;

{ ---- TTina4WebSocketClient ---- }

constructor TTina4WebSocketClient.Create(AOwner: TComponent);
begin
  inherited;
  FHeaders := TStringList.Create;
  FWriteLock := TCriticalSection.Create;
  FStateLock := TCriticalSection.Create;
  FPingWake := TEvent.Create(nil, True, False, '');       // manual-reset
  FReconnectWake := TEvent.Create(nil, True, False, '');  // manual-reset
  FAutoReconnect := True;
  FReconnectInterval := 3000;
  FReconnectMaxInterval := 60000;
  FReconnectMaxAttempts := 10;
  FPingInterval := 30000;
  FPongTimeout := 10000;
  FMaxConnectionAge := 0;  // off by default
  FConnectTimeout := 5000;
  FState := wsClosed;
  FReconnectAttempt := 0;
  FLastRTT := 0;
end;

destructor TTina4WebSocketClient.Destroy;
begin
  FAutoReconnect := False;
  // Wake any pending reconnect wait so it exits immediately on destroy.
  if Assigned(FReconnectWake) then FReconnectWake.SetEvent;
  // Set state directly — SetState fires OnStateChange via Queue which we
  // don't want during destruction.
  FState := wsClosed;

  // 1. Stop ping timer
  StopPingTimer;

  // Join the reconnect thread BEFORE freeing the wake event it waits on.
  if Assigned(FReconnectThread) then
  begin
    FReconnectThread.Terminate;
    if Assigned(FReconnectWake) then FReconnectWake.SetEvent;
    try FReconnectThread.WaitFor; except end;
    FreeAndNil(FReconnectThread);
  end;

  // 2. Stop read thread
  if Assigned(FReadThread) then
  begin
    FReadThread.Terminate;
    // Only close socket if networking is still available.
    // During app finalization Winsock may already be torn down.
    if (not UnitFinalized) and Assigned(FSocket) then
    begin
      try FSocket.Close(True); except end;
    end;
    {$IFDEF IOS}
    // Cancel the NW connection to unblock the read thread's pending receive.
    if Assigned(FNWConn) then
    begin
      try FNWConn.Shutdown; except end;
    end;
    {$ENDIF}
    try FReadThread.WaitFor; except end;
    FreeAndNil(FReadThread);
  end;

  // 3. Shut down and free SSL (only if OpenSSL is still loaded)
  if not UnitFinalized then
  begin
    if Assigned(FSSL) then
    begin
      try FSSL.Shutdown; except end;
      FreeAndNil(FSSL);
    end;
    FreeAndNil(FSocket);
  end
  else
  begin
    // During finalization, OpenSSL DLL is already unloaded.
    // Don't call FSSL.Free (it calls _SSL_free on a dead DLL).
    // Just nil the references — the OS reclaims everything on exit.
    FSSL := nil;
    FSocket := nil;
  end;
  {$IFDEF IOS}
  if Assigned(FNWConn) then
    FreeAndNil(FNWConn);
  {$ENDIF}

  FPingWake.Free;
  FReconnectWake.Free;
  FWriteLock.Free;
  FStateLock.Free;
  FHeaders.Free;
  inherited;
end;

function TTina4WebSocketClient.GetHeaders: TStrings;
begin
  Result := FHeaders;
end;

procedure TTina4WebSocketClient.SetHeaders(const Value: TStrings);
begin
  FHeaders.Assign(Value);
end;

{ ---- State (thread-safe) ---- }

function TTina4WebSocketClient.GetState: TTina4WSState;
begin
  // FStateLock isn't strictly required to read an enum-sized field on the
  // platforms we target, but it pairs with SetState so callers always see
  // a coherent snapshot relative to state-change events.
  FStateLock.Enter;
  try
    Result := FState;
  finally
    FStateLock.Leave;
  end;
end;

procedure TTina4WebSocketClient.SetState(ANewState: TTina4WSState);
var
  OldState: TTina4WSState;
  Changed: Boolean;
begin
  FStateLock.Enter;
  try
    OldState := FState;
    Changed := OldState <> ANewState;
    if Changed then
      FState := ANewState;
  finally
    FStateLock.Leave;
  end;
  if Changed then
    FireStateChange(OldState, ANewState);
end;

{ ---- Reconnect backoff ---- }

function TTina4WebSocketClient.ComputeBackoffMs(AAttempt: Integer): Integer;
var
  Base, JitterMs: Integer;
begin
  // Exponential backoff: ReconnectInterval * 2^(attempt-1), clamped to
  // ReconnectMaxInterval. Plus 0-25% jitter to avoid thundering-herd when
  // many clients reconnect simultaneously. Attempt 1 stays at ~ReconnectInterval
  // so existing apps see no behavior change on the first retry.
  if AAttempt < 1 then AAttempt := 1;
  if AAttempt > 16 then AAttempt := 16;  // cap shift to avoid Int overflow
  Base := FReconnectInterval shl (AAttempt - 1);
  if (Base <= 0) or (Base > FReconnectMaxInterval) then
    Base := FReconnectMaxInterval;
  if Base < 100 then Base := 100;
  // 0-25% additive jitter
  JitterMs := Random(Base div 4 + 1);
  Result := Base + JitterMs;
end;

{ ---- URL Parsing ---- }

procedure TTina4WebSocketClient.ParseURL;
var
  S: string;
  P: Integer;
begin
  S := FURL.Trim;

  // Scheme
  if S.StartsWith('wss://', True) then
  begin
    FUseTLS := True;
    FPort := 443;
    S := S.Substring(6);
  end
  else if S.StartsWith('ws://', True) then
  begin
    FUseTLS := False;
    FPort := 80;
    S := S.Substring(5);
  end
  else
    raise Exception.Create('URL must start with ws:// or wss://');

  // Path
  P := S.IndexOf('/');
  if P >= 0 then
  begin
    FPath := S.Substring(P);
    S := S.Substring(0, P);
  end
  else
    FPath := '/';

  // Host:Port
  P := S.IndexOf(':');
  if P >= 0 then
  begin
    FHost := S.Substring(0, P);
    FPort := StrToIntDef(S.Substring(P + 1), FPort);
  end
  else
    FHost := S;
end;

{ ---- Connection ---- }

procedure TTina4WebSocketClient.Connect;
begin
  if GetState in [wsOpen, wsConnecting] then
    Exit;

  FReconnectAttempt := 0;
  FAutoReconnect := True;  // refresh — Disconnect may have cleared it
  DoConnect;
end;

procedure TTina4WebSocketClient.DoConnect;
begin
  SetState(wsConnecting);

  // Run connection in a background thread so we don't block the main thread
  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        ParseURL;
        DoTCPConnect;

        if FUseTLS then
          DoTLSHandshake;

        DoWSHandshake;

        // Connection succeeded. Seed the watchdog clock NOW so the first
        // ping-tick window starts from a known point — otherwise a stale
        // FLastFrameAt from a previous connection could trip the watchdog
        // before any pings have flown.
        FLastFrameAt := Now;
        FLastPingSent := 0;
        FLastRTT := 0;
        FConnectedAt := Now;
        FReconnectAttempt := 0;
        SetState(wsOpen);
        FireConnected;

        // Start read thread
        FReadThread := TTina4WSReadThread.Create(Self);
        FReadThread.Start;

        // Start ping timer if configured
        if FPingInterval > 0 then
          StartPingTimer;

      except
        on E: Exception do
        begin
          FireError('Connect failed: ' + E.Message);
          // Clean up partial connection
          FreeAndNil(FSSL);
          {$IFDEF IOS}
          if Assigned(FNWConn) then
          begin
            try FNWConn.Shutdown; except end;
            FreeAndNil(FNWConn);
          end;
          {$ENDIF}
          if Assigned(FSocket) then
          begin
            try
              FSocket.Close(True);
            except
            end;
            FreeAndNil(FSocket);
          end;
          SetState(wsClosed);

          // Try reconnect if enabled
          if FAutoReconnect then
            DoReconnect;
        end;
      end;
    end
  ).Start;
end;

procedure TTina4WebSocketClient.DoTCPConnect;
var
  Endpoint: TNetEndpoint;
  ResolvedIP: string;
begin
  {$IFDEF IOS}
  // wss:// on iOS: Network.framework owns DNS + TCP + TLS in one step.
  // ws:// falls through to the normal cross-platform TSocket path below.
  if FUseTLS then
  begin
    FNWConn := TTina4NWConnection.Create;
    if not FNWConn.Connect(FHost, FPort, True, FConnectTimeout) then
    begin
      var NWErr := FNWConn.GetLastError;
      FreeAndNil(FNWConn);
      raise Exception.Create('Network.framework connect failed: ' + NWErr);
    end;
    Exit;
  end;
  {$ENDIF}

  ResolvedIP := ResolveHostName(FHost);
  if ResolvedIP = '' then
    raise Exception.Create('DNS resolution failed for ' + FHost);

  FSocket := TSocket.Create(TSocketType.TCP);
  try
    Endpoint := TNetEndpoint.Create(TIPAddress.Create(ResolvedIP), FPort);
    FSocket.Connect(Endpoint);
  except
    on E: Exception do
    begin
      FreeAndNil(FSocket);
      raise;
    end;
  end;
end;

procedure TTina4WebSocketClient.DoTLSHandshake;
var
  Err: string;
begin
  {$IFDEF IOS}
  // Network.framework already completed the TLS handshake during connect.
  if Assigned(FNWConn) then Exit;
  {$ENDIF}

  FSSL := TTina4SSLContext.Create;
  FSSL.HostName := FHost;
  if not FSSL.Init(FSocket.Handle) then
  begin
    Err := FSSL.GetLastError;
    FreeAndNil(FSSL);
    if Err <> '' then
      raise Exception.Create('TLS init failed: ' + Err)
    else
      raise Exception.Create('TLS init failed');
  end;

  if not FSSL.Connect then
  begin
    Err := FSSL.GetLastError;
    FreeAndNil(FSSL);
    if Err <> '' then
      raise Exception.Create('TLS handshake failed: ' + Err)
    else
      raise Exception.Create('TLS handshake failed');
  end;
end;

procedure TTina4WebSocketClient.DoWSHandshake;
var
  Key, Request, Line, Response, AcceptKey, ExpectedAccept: string;
  KeyBytes: TBytes;
  ResponseBytes: TBytes;
  I, StatusCode: Integer;
  GotUpgrade, GotAccept: Boolean;
begin
  // Generate random Sec-WebSocket-Key
  SetLength(KeyBytes, 16);
  for I := 0 to 15 do
    KeyBytes[I] := Byte(Random(256));
  Key := TNetEncoding.Base64.EncodeBytesToString(KeyBytes);

  // Build HTTP upgrade request with Host header
  if (FUseTLS and (FPort <> 443)) or (not FUseTLS and (FPort <> 80)) then
    Request := 'GET ' + FPath + ' HTTP/1.1' + #13#10 +
               'Host: ' + FHost + ':' + IntToStr(FPort) + #13#10
  else
    Request := 'GET ' + FPath + ' HTTP/1.1' + #13#10 +
               'Host: ' + FHost + #13#10;
  Request := Request +
             'Upgrade: websocket' + #13#10 +
             'Connection: Upgrade' + #13#10 +
             'Sec-WebSocket-Key: ' + Key + #13#10 +
             'Sec-WebSocket-Version: 13' + #13#10;

  // Add custom headers
  for I := 0 to FHeaders.Count - 1 do
    Request := Request + FHeaders[I] + #13#10;

  Request := Request + #13#10;

  // Send handshake
  ResponseBytes := TEncoding.UTF8.GetBytes(Request);
  RawSend(ResponseBytes);

  // Read HTTP response line by line
  Response := '';
  repeat
    Line := '';
    var C: Byte;
    repeat
      C := RawRecvByte;
      if C = 13 then // CR
      begin
        RawRecvByte; // consume LF
        Break;
      end;
      Line := Line + Char(C);
    until False;

    if Line = '' then
      Break; // Empty line = end of headers

    Response := Response + Line + #13#10;
  until False;

  // Validate HTTP 101 response
  I := Pos(' ', Response);
  if I > 0 then
  begin
    var StatusStr := Copy(Response, I + 1, 3);
    StatusCode := StrToIntDef(StatusStr, 0);
  end
  else
    StatusCode := 0;

  if StatusCode <> 101 then
    raise Exception.Create('WebSocket handshake failed: HTTP ' +
      IntToStr(StatusCode));

  // Validate Sec-WebSocket-Accept
  ExpectedAccept := TNetEncoding.Base64.EncodeBytesToString(
    THashSHA1.GetHashBytes(Key + WS_GUID));

  GotUpgrade := False;
  GotAccept := False;

  for Line in Response.Split([#13#10]) do
  begin
    if Line.Trim.ToLower.StartsWith('upgrade:') and
       Line.Trim.ToLower.Contains('websocket') then
      GotUpgrade := True;

    if Line.Trim.ToLower.StartsWith('sec-websocket-accept:') then
    begin
      AcceptKey := Line.Substring(Line.IndexOf(':') + 1).Trim;
      if AcceptKey = ExpectedAccept then
        GotAccept := True;
    end;
  end;

  if not GotUpgrade then
    raise Exception.Create('Server did not confirm WebSocket upgrade');
  if not GotAccept then
    raise Exception.Create('Server Sec-WebSocket-Accept mismatch');
end;

{ ---- Low-level I/O ---- }

procedure TTina4WebSocketClient.RawSend(const AData: TBytes);
var
  Sent, Total, Ret: Integer;
begin
  // Allow sends during the handshake too — the WS upgrade request
  // is dispatched while FState is still wsConnecting. Only block on
  // states where the socket is gone (wsClosed, wsClosing).
  if GetState in [wsClosed, wsClosing] then Exit;
  FWriteLock.Enter;
  try
    {$IFDEF IOS}
    if (not Assigned(FSocket)) and (not Assigned(FNWConn)) then Exit;
    {$ELSE}
    if not Assigned(FSocket) then Exit; // socket already freed
    {$ENDIF}
    Total := Length(AData);
    Sent := 0;
    while Sent < Total do
    begin
      {$IFDEF IOS}
      if Assigned(FNWConn) then
        Ret := FNWConn.Write(@AData[Sent], Total - Sent)
      else
      {$ENDIF}
      if FUseTLS and Assigned(FSSL) then
        Ret := FSSL.Write(@AData[Sent], Total - Sent)
      else
        Ret := FSocket.Send(AData, Sent, Total - Sent);

      if Ret <= 0 then
        raise Exception.Create('Socket send failed');
      Inc(Sent, Ret);
    end;
  finally
    FWriteLock.Leave;
  end;
end;

function TTina4WebSocketClient.RawRecv(ALen: Integer): TBytes;
var
  Received, Ret: Integer;
begin
  SetLength(Result, ALen);
  Received := 0;
  while Received < ALen do
  begin
    {$IFDEF IOS}
    if Assigned(FNWConn) then
      Ret := FNWConn.Read(@Result[Received], ALen - Received)
    else
    {$ENDIF}
    if FUseTLS and Assigned(FSSL) then
      Ret := FSSL.Read(@Result[Received], ALen - Received)
    else
    begin
      var Buf: TBytes;
      Buf := FSocket.Receive(ALen - Received);
      Ret := Length(Buf);
      if Ret > 0 then
        Move(Buf[0], Result[Received], Ret);
    end;

    if Ret <= 0 then
      raise Exception.Create('Socket receive failed');
    Inc(Received, Ret);
  end;
end;

function TTina4WebSocketClient.RawRecvByte: Byte;
var
  Buf: TBytes;
begin
  Buf := RawRecv(1);
  Result := Buf[0];
end;

{ ---- WebSocket Frame Encoding ---- }

function TTina4WebSocketClient.EncodeFrame(AOpcode: Byte;
  const APayload: TBytes): TBytes;
begin
  // Client always masks (RFC 6455 requires it). Server side will pass
  // AMask=False — same Tina4WebSocketFrames.EncodeFrame, different flag.
  Result := Tina4WebSocketFrames.EncodeFrame(AOpcode, APayload, True);
end;

{ ---- Frame Processing ---- }

procedure TTina4WebSocketClient.ProcessFrame(AOpcode: Byte;
  const APayload: TBytes);
var
  CloseCode: Integer;
  CloseReason: string;
  PongFrame: TBytes;
begin
  // ANY frame counts as proof-of-life — text, binary, ping, pong all reset
  // the watchdog. The watchdog only fires when nothing has arrived for
  // PingInterval + PongTimeout.
  FLastFrameAt := Now;

  case AOpcode of
    WS_OP_TEXT:
      begin
        if APayload <> nil then
          FireMessage(TEncoding.UTF8.GetString(APayload))
        else
          FireMessage('');
      end;

    WS_OP_BINARY:
      FireBinary(APayload);

    WS_OP_PING:
      begin
        // Auto-reply with pong (same payload)
        try
          PongFrame := EncodeFrame(WS_OP_PONG, APayload);
          RawSend(PongFrame);
        except
          // Ignore send errors during pong
        end;
      end;

    WS_OP_PONG:
      begin
        // Record the round-trip from our last ping. Multiple pings in
        // flight are rare in practice (ping interval >> RTT), so the
        // single-slot FLastPingSent is enough.
        if FLastPingSent > 0 then
        begin
          FLastRTT := MilliSecondsBetween(Now, FLastPingSent);
          FLastPingSent := 0;
        end;
      end;

    WS_OP_CLOSE:
      begin
        ParseClosePayload(APayload, CloseCode, CloseReason);

        // Echo close frame back if we haven't sent one yet
        if GetState = wsOpen then
        begin
          SetState(wsClosing);
          try
            var CloseFrame := EncodeFrame(WS_OP_CLOSE, APayload);
            RawSend(CloseFrame);
          except
          end;
        end;

        DoDisconnectInternal(CloseCode, CloseReason, False);
      end;
  end;
end;

{ ---- Send ---- }

procedure TTina4WebSocketClient.Send(const AMessage: string);
var
  Payload, Frame: TBytes;
begin
  if GetState <> wsOpen then
    raise Exception.Create('WebSocket is not connected');

  Payload := TEncoding.UTF8.GetBytes(AMessage);
  Frame := EncodeFrame(WS_OP_TEXT, Payload);
  RawSend(Frame);
end;

procedure TTina4WebSocketClient.Send(const AData: TBytes);
var
  Frame: TBytes;
begin
  if GetState <> wsOpen then
    raise Exception.Create('WebSocket is not connected');

  Frame := EncodeFrame(WS_OP_BINARY, AData);
  RawSend(Frame);
end;

{ ---- Disconnect ---- }

procedure TTina4WebSocketClient.Disconnect;
begin
  Disconnect(1000, 'Normal closure');
end;

procedure TTina4WebSocketClient.Disconnect(ACode: Integer;
  const AReason: string);
var
  ClosePayload, ReasonBytes, Frame: TBytes;
  Cur: TTina4WSState;
begin
  FAutoReconnect := False; // explicit disconnect = no reconnect
  StopPingTimer;
  // Wake any pending reconnect backoff so the wait collapses.
  if Assigned(FReconnectWake) then FReconnectWake.SetEvent;

  Cur := GetState;
  if Cur = wsOpen then
  begin
    SetState(wsClosing);

    // RFC 6455 §5.5.1 close payload: 2-byte status code + optional UTF-8
    // reason. Code 1000 = normal, 1001 = going-away (mobile background /
    // logout), 4000-4999 = application-private.
    if AReason <> '' then
    begin
      ReasonBytes := TEncoding.UTF8.GetBytes(AReason);
      SetLength(ClosePayload, 2 + Length(ReasonBytes));
      if Length(ReasonBytes) > 0 then
        Move(ReasonBytes[0], ClosePayload[2], Length(ReasonBytes));
    end
    else
      SetLength(ClosePayload, 2);
    ClosePayload[0] := Byte(ACode shr 8);
    ClosePayload[1] := Byte(ACode);
    try
      Frame := EncodeFrame(WS_OP_CLOSE, ClosePayload);
      RawSend(Frame);
    except
    end;

    DoDisconnectInternal(ACode, AReason, False);
  end
  else if Cur in [wsConnecting, wsReconnecting] then
  begin
    DoDisconnectInternal(ACode, 'Cancelled', False);
  end;
end;

procedure TTina4WebSocketClient.ForceReconnect;
begin
  // Path used by "app resumed from background / network changed". The
  // current socket is probably stale (cellular handoff, WiFi switch, NAT
  // reset, OS suspended the link). Tear down without firing the AutoReconnect
  // gate and reconnect immediately, regardless of MaxAttempts.
  FForceReconnect := True;
  FAutoReconnect := True;
  FReconnectAttempt := 0;
  // Wake any in-flight backoff wait so it doesn't keep us idle.
  if Assigned(FReconnectWake) then FReconnectWake.SetEvent;
  // If we're already open we go through the normal close path so the server
  // sees a clean 1001 going-away rather than a half-open socket.
  if GetState = wsOpen then
    DoDisconnectInternal(1001, 'Going away (force reconnect)', True)
  else
    // Otherwise just kick the state machine: from wsClosed / wsConnecting /
    // wsClosing fall through to a fresh DoConnect.
    DoReconnect;
end;

procedure TTina4WebSocketClient.NotifyNetworkChanged;
var
  PingFrame: TBytes;
begin
  // Non-destructive probe — preferred to ForceReconnect when the app just
  // wants to verify the link is still alive (e.g. screen wake, BG -> FG).
  // Sends a ping NOW and shortens the watchdog clock so a dead link is
  // detected within PongTimeout (default 10s) rather than the full
  // PingInterval. If the pong returns, the existing connection survives
  // without any disconnect / reconnect churn — UI stays calm.
  if GetState <> wsOpen then
  begin
    // No open connection to probe. If a reconnect backoff is in progress,
    // collapse the wait so we retry now.
    if Assigned(FReconnectWake) then FReconnectWake.SetEvent;
    Exit;
  end;
  try
    PingFrame := EncodeFrame(WS_OP_PING, nil);
    RawSend(PingFrame);
    FLastPingSent := Now;
    // Pull the watchdog deadline forward: pretend the last received frame
    // was PingInterval ago, so the watchdog window collapses to PongTimeout.
    FLastFrameAt := IncMilliSecond(Now, -FPingInterval);
  except
    // Send failed -> socket is gone. Force a reconnect.
    DoDisconnectInternal(1006, 'Network change probe failed', True);
  end;
end;

procedure TTina4WebSocketClient.DoDisconnectInternal(ACode: Integer;
  const AReason: string; AStartReconnect: Boolean);
var
  CalledFromReader: Boolean;
begin
  // Atomic state guard: only the caller who actually flips wsClosed wins.
  // Multiple paths can race into this (read thread error, explicit
  // Disconnect, watchdog) — without the lock both could half-tear-down.
  FStateLock.Enter;
  try
    if FState = wsClosed then Exit;
    FState := wsClosed;
  finally
    FStateLock.Leave;
  end;
  FireStateChange(wsClosing, wsClosed);

  CalledFromReader := Assigned(FReadThread) and
                      (TThread.CurrentThread.ThreadID = FReadThread.ThreadID);

  // 1. Stop ping timer — it calls RawSend which uses FSocket/FSSL
  StopPingTimer;

  // 2. Stop read thread
  if Assigned(FReadThread) then
    FReadThread.Terminate;

  // 3. Close socket to unblock recv
  if Assigned(FSocket) then
  begin
    try
      FSocket.Close(True);
    except
    end;
  end;
  {$IFDEF IOS}
  // Cancel the Network.framework connection so the read thread's pending
  // receive completes and the thread can exit.
  if Assigned(FNWConn) then
  begin
    try FNWConn.Shutdown; except end;
  end;
  {$ENDIF}

  // 4. Join read thread
  if Assigned(FReadThread) and not CalledFromReader then
  begin
    try
      FReadThread.WaitFor;
    except
    end;
    FreeAndNil(FReadThread);
  end
  else if CalledFromReader then
  begin
    FReadThread.FreeOnTerminate := True;
    FReadThread := nil;
  end;

  // 5. Shut down and free SSL (skip if OpenSSL DLL already unloaded)
  if not UnitFinalized then
  begin
    if Assigned(FSSL) then
    begin
      try FSSL.Shutdown; except end;
      FreeAndNil(FSSL);
    end;
    FreeAndNil(FSocket);
  end
  else
  begin
    FSSL := nil;
    FSocket := nil;
  end;
  {$IFDEF IOS}
  // Network.framework is a system framework — always safe to free, even at
  // unit finalization (no DLL to have been unloaded).
  if Assigned(FNWConn) then
    FreeAndNil(FNWConn);
  {$ENDIF}

  // 7. Notify — but not during destruction (main thread may be gone)
  if not (csDestroying in ComponentState) then
    FireDisconnected(ACode, AReason);

  // 8. Auto-reconnect on unexpected disconnect
  if AStartReconnect and FAutoReconnect and
     not (csDestroying in ComponentState) then
    DoReconnect;
end;

{ ---- Reconnect ---- }

procedure TTina4WebSocketClient.DoReconnect;
var
  DelayMs: Integer;
  ForceThisAttempt: Boolean;
begin
  if not FAutoReconnect then
    Exit;

  // Snapshot + clear the force flag so a single ForceReconnect bypasses the
  // attempt cap exactly once.
  ForceThisAttempt := FForceReconnect;
  FForceReconnect := False;

  Inc(FReconnectAttempt);

  if (not ForceThisAttempt) and
     (FReconnectMaxAttempts > 0) and
     (FReconnectAttempt > FReconnectMaxAttempts) then
  begin
    FireError('Max reconnect attempts (' +
      IntToStr(FReconnectMaxAttempts) + ') exceeded');
    SetState(wsClosed);
    Exit;
  end;

  SetState(wsReconnecting);
  FireReconnecting(FReconnectAttempt);

  // ForceReconnect skips the backoff entirely (user already paid the wait
  // by being offline). Normal attempts use exponential backoff + jitter.
  if ForceThisAttempt then
    DelayMs := 0
  else
    DelayMs := ComputeBackoffMs(FReconnectAttempt);

  // Cancellable wait: ForceReconnect / Disconnect / NotifyNetworkChanged
  // signal FReconnectWake to break out.
  FReconnectWake.ResetEvent;

  // Join any previous reconnect thread before spawning a new one.
  if Assigned(FReconnectThread) then
  begin
    try FReconnectThread.WaitFor; except end;
    FreeAndNil(FReconnectThread);
  end;

  FReconnectThread := TThread.CreateAnonymousThread(
    procedure
    begin
      if DelayMs > 0 then
        FReconnectWake.WaitFor(DelayMs);
      if FAutoReconnect and (GetState = wsReconnecting) then
        DoConnect;
    end);
  FReconnectThread.FreeOnTerminate := False;
  FReconnectThread.Start;
end;

{ ---- Ping Timer ---- }

procedure TTina4WebSocketClient.StartPingTimer;
begin
  StopPingTimer;
  if FPingInterval <= 0 then
    Exit;

  FPingWake.ResetEvent;

  // Mobile bullet-proofing: this thread now does THREE jobs.
  //   1. Sends keepalive pings every FPingInterval.
  //   2. Watchdog — if no frame (of any kind) has arrived for
  //      FPingInterval + FPongTimeout, the link is silently dead
  //      (cellular handoff / NAT timeout / OS-suspended socket).
  //      Force a reconnect immediately rather than waiting for the
  //      OS TCP timeout (often 5-15 minutes).
  //   3. Connection-age rotation — if FMaxConnectionAge > 0 and the
  //      connection has been up longer than that, gracefully rotate
  //      to defeat middlebox state-table drops on long-lived sockets.
  // The wait quantum is min(PingInterval, 1000ms) so the watchdog can
  // react quickly even when PingInterval is long.
  FPingTimer := TThread.CreateAnonymousThread(
    procedure
    var
      PingFrame: TBytes;
      WaitMs, ElapsedSincePing, ElapsedSinceFrame: Integer;
      WatchdogMs: Integer;
    begin
      while not TThread.Current.CheckTerminated and (GetState = wsOpen) do
      begin
        // Short wait quantum to allow timely watchdog firing even when
        // PingInterval is set to, say, 5 minutes for low-traffic apps.
        WaitMs := FPingInterval;
        if WaitMs > 1000 then WaitMs := 1000;
        if FPongTimeout > 0 then
        begin
          if WaitMs > FPongTimeout div 2 then WaitMs := FPongTimeout div 2;
          if WaitMs < 250 then WaitMs := 250;
        end;
        if FPingWake.WaitFor(WaitMs) = wrSignaled then
          Break;
        if TThread.Current.CheckTerminated or (GetState <> wsOpen) then
          Break;

        // Watchdog. PongTimeout = 0 disables it.
        if FPongTimeout > 0 then
        begin
          WatchdogMs := FPingInterval + FPongTimeout;
          ElapsedSinceFrame := MilliSecondsBetween(Now, FLastFrameAt);
          if ElapsedSinceFrame > WatchdogMs then
          begin
            FireError(Format('Watchdog: no frame for %d ms (limit %d)',
              [ElapsedSinceFrame, WatchdogMs]));
            DoDisconnectInternal(1006,
              'Watchdog: no traffic from server', True);
            Break;
          end;
        end;

        // Connection-age rotation. 0 = disabled.
        if (FMaxConnectionAge > 0) and (FConnectedAt > 0) and
           (MilliSecondsBetween(Now, FConnectedAt) > FMaxConnectionAge) then
        begin
          FForceReconnect := True;
          DoDisconnectInternal(1001,
            'Going away (connection age rotation)', True);
          Break;
        end;

        // Ping cadence — emit a ping once per FPingInterval. We only
        // arm a new FLastPingSent when there isn't one already (so
        // back-to-back pings don't clobber the RTT measurement).
        // FLastPingSent = 0 is the "no ping in flight" sentinel; TDateTime(0)
        // is 1899, so MilliSecondsBetween against it overflows Integer — only
        // compute the elapsed time when a ping is actually outstanding.
        if FLastPingSent = 0 then
          ElapsedSincePing := 0
        else
          ElapsedSincePing := MilliSecondsBetween(Now, FLastPingSent);
        if (FLastPingSent = 0) or (ElapsedSincePing >= FPingInterval) then
        begin
          try
            PingFrame := EncodeFrame(WS_OP_PING, nil);
            RawSend(PingFrame);
            if FLastPingSent = 0 then FLastPingSent := Now;
          except
            // Send failed — socket is gone. Trigger reconnect.
            DoDisconnectInternal(1006, 'Ping send failed', True);
            Break;
          end;
        end;
      end;
    end
  );
  FPingTimer.FreeOnTerminate := False;
  FPingTimer.Start;
end;

procedure TTina4WebSocketClient.StopPingTimer;
begin
  if Assigned(FPingTimer) then
  begin
    FPingTimer.Terminate;
    FPingWake.SetEvent;  // wake the wait so the thread exits immediately
    FPingTimer.WaitFor;
    FreeAndNil(FPingTimer);
  end;
end;

{ ---- Event Dispatchers ---- }

procedure TTina4WebSocketClient.FireConnected;
begin
  if Assigned(FOnConnected) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnConnected) then
          FOnConnected(Self);
      end);
end;

procedure TTina4WebSocketClient.FireDisconnected(ACode: Integer;
  const AReason: string);
begin
  if Assigned(FOnDisconnected) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnDisconnected) then
          FOnDisconnected(Self, ACode, AReason);
      end);
end;

procedure TTina4WebSocketClient.FireMessage(const AMsg: string);
begin
  if Assigned(FOnMessage) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnMessage) then
          FOnMessage(Self, AMsg);
      end);
end;

procedure TTina4WebSocketClient.FireBinary(const AData: TBytes);
begin
  if Assigned(FOnBinaryReceived) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnBinaryReceived) then
          FOnBinaryReceived(Self, AData);
      end);
end;

procedure TTina4WebSocketClient.FireError(const AError: string);
begin
  if Assigned(FOnError) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnError) then
          FOnError(Self, AError);
      end);
end;

procedure TTina4WebSocketClient.FireReconnecting(AAttempt: Integer);
begin
  if Assigned(FOnReconnecting) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnReconnecting) then
          FOnReconnecting(Self, AAttempt);
      end);
end;

procedure TTina4WebSocketClient.FireStateChange(AOldState,
  ANewState: TTina4WSState);
begin
  if csDestroying in ComponentState then Exit;
  if Assigned(FOnStateChange) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FOnStateChange) then
          FOnStateChange(Self, AOldState, ANewState);
      end);
end;

function TTina4WebSocketClient.IsConnected: Boolean;
begin
  Result := GetState = wsOpen;
end;

initialization
  Randomize;

finalization
  UnitFinalized := True;

end.
