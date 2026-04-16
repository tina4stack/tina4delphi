unit Tina4WebSocketServer;

{
  Tina4WebSocketServer

  Self-contained WebSocket server (RFC 6455) with no third-party
  dependencies. Pairs with Tina4WebSocketClient — both share frame
  encode/decode through Tina4WebSocketFrames.

  Architecture:
    * One acceptor thread runs the listening socket and spawns a
      TTina4WSConnection per accepted client.
    * Each connection has its own read thread that loops on
      Tina4WebSocketFrames.ReadFrame and dispatches text/binary/close
      to the server's events.
    * Sends from any thread are serialized per-connection via a
      critical section.

  This unit is the raw protocol layer only. Pub-sub semantics
  (rooms, subscribe/publish/ack) live in a separate broker layer
  on top — keep one responsibility per file.
}

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Net.Socket,
  System.Generics.Collections,
  Tina4WebSocketFrames, Tina4OpenSSL;

type
  TTina4WebSocketServer = class;
  TTina4WSConnection = class;

  /// <summary>Per-connection event signatures.</summary>
  TTina4WSSrvConnectEvent    = procedure(Sender: TObject;
                                         Connection: TTina4WSConnection) of object;
  TTina4WSSrvDisconnectEvent = procedure(Sender: TObject;
                                         Connection: TTina4WSConnection;
                                         ACode: Integer;
                                         const AReason: string) of object;
  TTina4WSSrvMessageEvent    = procedure(Sender: TObject;
                                         Connection: TTina4WSConnection;
                                         const AMessage: string) of object;
  TTina4WSSrvBinaryEvent     = procedure(Sender: TObject;
                                         Connection: TTina4WSConnection;
                                         const AData: TBytes) of object;
  TTina4WSSrvErrorEvent      = procedure(Sender: TObject;
                                         Connection: TTina4WSConnection;
                                         const AError: string) of object;

  /// <summary>
  /// One live client. Owned by the server; do not free directly. Use
  /// Send to push frames (thread-safe per connection).
  /// </summary>
  TTina4WSConnection = class
  private
    FServer: TTina4WebSocketServer;
    FSocket: TSocket;
    FSSL: TTina4SSLConnection;  // nil for ws://, set for wss://
    FReadThread: TThread;
    FWriteLock: TCriticalSection;
    FOpen: Boolean;
    FRemoteAddr: string;
    FUserData: TObject;
    FHandshakeHeaders: TStringList;
    procedure RawSend(const AData: TBytes);
    function RawRecv(ALen: Integer): TBytes;
    procedure CloseSocket;
  public
    constructor Create(AServer: TTina4WebSocketServer; ASocket: TSocket);
    destructor Destroy; override;
    procedure Send(const AMessage: string); overload;
    procedure Send(const AData: TBytes); overload;
    procedure Close(ACode: Integer = WS_CLOSE_NORMAL;
      const AReason: string = '');
    function IsOpen: Boolean;
    /// <summary>Headers from the upgrade request, lower-cased keys.</summary>
    property HandshakeHeaders: TStringList read FHandshakeHeaders;
    property RemoteAddr: string read FRemoteAddr;
    /// <summary>Optional opaque per-connection state for higher layers.</summary>
    property UserData: TObject read FUserData write FUserData;
  end;

  /// <summary>
  /// WebSocket server. Listen() spawns the accept loop in a background
  /// thread and returns immediately. All event handlers are invoked on
  /// the connection's read thread, NOT the main thread — push UI work
  /// across with TThread.Queue if you need it.
  /// </summary>
  TTina4WebSocketServer = class
  private
    FListener: TSocket;
    FAcceptThread: TThread;
    FConnections: TList<TTina4WSConnection>;
    FConnectionsLock: TCriticalSection;
    FRunning: Boolean;
    FPort: Integer;
    FBindHost: string;
    FSSLCtx: TTina4SSLServerContext;  // nil for ws://, set for wss://
    FOnConnect: TTina4WSSrvConnectEvent;
    FOnDisconnect: TTina4WSSrvDisconnectEvent;
    FOnMessage: TTina4WSSrvMessageEvent;
    FOnBinary: TTina4WSSrvBinaryEvent;
    FOnError: TTina4WSSrvErrorEvent;
    procedure RegisterConnection(AConn: TTina4WSConnection);
    procedure UnregisterConnection(AConn: TTina4WSConnection);
    procedure FireConnect(AConn: TTina4WSConnection);
    procedure FireDisconnect(AConn: TTina4WSConnection;
      ACode: Integer; const AReason: string);
    procedure FireMessage(AConn: TTina4WSConnection; const AMsg: string);
    procedure FireBinary(AConn: TTina4WSConnection; const AData: TBytes);
    procedure FireError(AConn: TTina4WSConnection; const AError: string);
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// Loads a PEM cert + private key. Once called, every accepted
    /// connection is wrapped in TLS (wss://). Must be called before
    /// Listen(). Returns False if OpenSSL isn't available, the files
    /// can't be read, or the key doesn't match the cert.
    /// </summary>
    function UseCertificate(const ACertFile, AKeyFile: string): Boolean;
    /// <summary>True once a cert has been successfully loaded.</summary>
    function UsesTLS: Boolean;
    /// <summary>
    /// Starts the listener on APort. If ABindHost is empty, listens on
    /// 0.0.0.0 (all interfaces). Returns immediately; tear down with Stop.
    /// </summary>
    procedure Listen(APort: Integer; const ABindHost: string = '');
    /// <summary>Stops accepting and closes every live connection.</summary>
    procedure Stop;
    /// <summary>Number of currently open connections.</summary>
    function ClientCount: Integer;
    /// <summary>
    /// Snapshot of current connections. Returned list is safe to iterate;
    /// the underlying connections may close mid-iteration so test IsOpen.
    /// </summary>
    function Snapshot: TArray<TTina4WSConnection>;
    property Port: Integer read FPort;
    property OnConnect: TTina4WSSrvConnectEvent
      read FOnConnect write FOnConnect;
    property OnDisconnect: TTina4WSSrvDisconnectEvent
      read FOnDisconnect write FOnDisconnect;
    property OnMessage: TTina4WSSrvMessageEvent
      read FOnMessage write FOnMessage;
    property OnBinary: TTina4WSSrvBinaryEvent
      read FOnBinary write FOnBinary;
    property OnError: TTina4WSSrvErrorEvent
      read FOnError write FOnError;
  end;

implementation

uses
  System.NetEncoding, System.Hash, System.StrUtils, System.Types;

type
  // Background thread that loops on Accept() and spawns connections.
  TWSAcceptThread = class(TThread)
  private
    FServer: TTina4WebSocketServer;
  protected
    procedure Execute; override;
  public
    constructor Create(AServer: TTina4WebSocketServer);
  end;

  // Per-connection read loop: handshake first, then frame dispatch.
  TWSConnReadThread = class(TThread)
  private
    FConn: TTina4WSConnection;
    FCloseCode: Integer;
    FCloseReason: string;
    function PerformHandshake: Boolean;
    procedure RunFrameLoop;
  protected
    procedure Execute; override;
  public
    constructor Create(AConn: TTina4WSConnection);
  end;

{ ---- TWSAcceptThread ---- }

constructor TWSAcceptThread.Create(AServer: TTina4WebSocketServer);
begin
  inherited Create(True);  // suspended; caller starts
  FreeOnTerminate := False;
  FServer := AServer;
end;

procedure TWSAcceptThread.Execute;
var
  ClientSocket: TSocket;
  Conn: TTina4WSConnection;
begin
  while not Terminated and FServer.FRunning do
  begin
    try
      // Blocking accept. Stop() closes the listener, which makes
      // Accept raise — caught and used as the loop exit signal.
      ClientSocket := FServer.FListener.Accept;
    except
      // Listener closed by Stop, or socket error — exit the loop.
      Break;
    end;

    if (ClientSocket = nil) or (not FServer.FRunning) then
    begin
      if ClientSocket <> nil then
      begin
        try ClientSocket.Close(True); except end;
        ClientSocket.Free;
      end;
      Break;
    end;

    // Hand the socket off to a connection wrapper. The connection's
    // read thread runs the handshake and then the frame loop.
    Conn := TTina4WSConnection.Create(FServer, ClientSocket);
    FServer.RegisterConnection(Conn);
    Conn.FReadThread := TWSConnReadThread.Create(Conn);
    TWSConnReadThread(Conn.FReadThread).Start;
  end;
end;

{ ---- TWSConnReadThread ---- }

constructor TWSConnReadThread.Create(AConn: TTina4WSConnection);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FConn := AConn;
  FCloseCode := WS_CLOSE_NORMAL;
  FCloseReason := '';
end;

function TWSConnReadThread.PerformHandshake: Boolean;
var
  Line, RequestLine, Key, Accept, LowerLine, HeaderName, HeaderValue: string;
  ColonPos: Integer;
  C: Byte;
  RecvBytes: TBytes;
  Response: TBytes;
  ResponseStr: string;
begin
  Result := False;
  RequestLine := '';
  Key := '';

  // Read header lines terminated by CRLF, stop at the empty line.
  // Each line is read byte-by-byte to keep the parser tolerant of
  // odd line endings without needing a buffered reader.
  while True do
  begin
    Line := '';
    while True do
    begin
      RecvBytes := FConn.RawRecv(1);
      if Length(RecvBytes) = 0 then Exit;  // disconnect mid-handshake
      C := RecvBytes[0];
      if C = 13 then
      begin
        // Consume the LF that follows
        RecvBytes := FConn.RawRecv(1);
        Break;
      end;
      Line := Line + Char(C);
      if Length(Line) > 8192 then Exit;  // sanity cap
    end;

    if Line = '' then Break;  // end of headers

    if RequestLine = '' then
    begin
      RequestLine := Line;
      Continue;
    end;

    ColonPos := Pos(':', Line);
    if ColonPos > 0 then
    begin
      HeaderName := Trim(LowerCase(Copy(Line, 1, ColonPos - 1)));
      HeaderValue := Trim(Copy(Line, ColonPos + 1, MaxInt));
      FConn.FHandshakeHeaders.Values[HeaderName] := HeaderValue;
      if HeaderName = 'sec-websocket-key' then
        Key := HeaderValue;
    end;
  end;

  // Validate: GET request, has Upgrade: websocket, has Sec-WebSocket-Key
  LowerLine := LowerCase(RequestLine);
  if not LowerLine.StartsWith('get ') then Exit;
  if LowerCase(FConn.FHandshakeHeaders.Values['upgrade']) <> 'websocket' then Exit;
  if Key = '' then Exit;

  // Compute the accept value: base64(sha1(key + GUID)) per RFC 6455.
  Accept := TNetEncoding.Base64.EncodeBytesToString(
    THashSHA1.GetHashBytes(Key + WS_GUID));

  ResponseStr :=
    'HTTP/1.1 101 Switching Protocols' + #13#10 +
    'Upgrade: websocket' + #13#10 +
    'Connection: Upgrade' + #13#10 +
    'Sec-WebSocket-Accept: ' + Accept + #13#10 +
    #13#10;
  Response := TEncoding.UTF8.GetBytes(ResponseStr);
  FConn.RawSend(Response);
  FConn.FOpen := True;
  Result := True;
end;

procedure TWSConnReadThread.RunFrameLoop;
var
  Frame: TTina4WSFrame;
  PongFrame: TBytes;
begin
  while not Terminated and FConn.FOpen do
  begin
    try
      Frame := ReadFrame(
        function(ALen: Integer): TBytes
        begin
          Result := FConn.RawRecv(ALen);
          if Length(Result) < ALen then
            raise Exception.Create('Short read');
        end);
    except
      // Read failed — peer closed, network blip, or we're shutting down.
      // Flag abnormal close; FireDisconnect is dispatched in Execute's
      // finally block after the loop exits.
      FCloseCode := WS_CLOSE_ABNORMAL;
      FCloseReason := 'Connection lost';
      FConn.FOpen := False;
      Break;
    end;

    case Frame.Opcode of
      WS_OP_TEXT:
        if Frame.Payload <> nil then
          FConn.FServer.FireMessage(FConn, TEncoding.UTF8.GetString(Frame.Payload))
        else
          FConn.FServer.FireMessage(FConn, '');

      WS_OP_BINARY:
        FConn.FServer.FireBinary(FConn, Frame.Payload);

      WS_OP_PING:
        // Echo back as pong with same payload (RFC 6455 §5.5.3).
        try
          PongFrame := EncodeFrame(WS_OP_PONG, Frame.Payload, False);
          FConn.RawSend(PongFrame);
        except
        end;

      WS_OP_PONG:
        ; // no-op

      WS_OP_CLOSE:
        begin
          ParseClosePayload(Frame.Payload, FCloseCode, FCloseReason);
          // Echo a close frame back if we haven't sent one already,
          // then exit the loop.
          try
            var EchoClose := EncodeFrame(WS_OP_CLOSE,
              BuildClosePayload(FCloseCode, FCloseReason), False);
            FConn.RawSend(EchoClose);
          except
          end;
          FConn.FOpen := False;
          Break;
        end;
    end;
  end;
end;

procedure TWSConnReadThread.Execute;
var
  TLSOk: Boolean;
begin
  try
    try
      // wss:// path — wrap the accepted TCP socket with TLS BEFORE
      // running the WS upgrade. SSL_accept blocks the thread until
      // the handshake completes; the upgrade then flows through SSL.
      if FConn.FServer.UsesTLS then
      begin
        FConn.FSSL := TTina4SSLConnection.Create;
        TLSOk := FConn.FSSL.AcceptOn(FConn.FServer.FSSLCtx,
          THandle(FConn.FSocket.Handle));
        if not TLSOk then
        begin
          FConn.FServer.FireError(FConn,
            'TLS handshake failed: ' + FConn.FSSL.GetLastError);
          FCloseCode := WS_CLOSE_PROTOCOL_ERROR;
          FCloseReason := 'TLS handshake failed';
          FreeAndNil(FConn.FSSL);
          Exit;
        end;
      end;

      if PerformHandshake then
      begin
        FConn.FServer.FireConnect(FConn);
        RunFrameLoop;
      end
      else
      begin
        FCloseCode := WS_CLOSE_PROTOCOL_ERROR;
        FCloseReason := 'Handshake failed';
      end;
    except
      on E: Exception do
      begin
        FCloseCode := WS_CLOSE_INTERNAL_ERROR;
        FCloseReason := 'Exception: ' + E.Message;
        FConn.FServer.FireError(FConn, E.Message);
      end;
    end;
  finally
    if FConn.FOpen then
    begin
      FConn.FServer.FireDisconnect(FConn, FCloseCode, FCloseReason);
      FConn.FOpen := False;
    end
    else if FCloseCode <> WS_CLOSE_NORMAL then
      // Even if FOpen never flipped true, fire disconnect so callers
      // see the failed handshake.
      FConn.FServer.FireDisconnect(FConn, FCloseCode, FCloseReason);
    FConn.CloseSocket;
    FConn.FServer.UnregisterConnection(FConn);
    // The connection self-destructs once its read thread exits — no
    // other thread holds a reference at this point.
    FConn.Free;
  end;
end;

{ ---- TTina4WSConnection ---- }

constructor TTina4WSConnection.Create(AServer: TTina4WebSocketServer;
  ASocket: TSocket);
begin
  inherited Create;
  FServer := AServer;
  FSocket := ASocket;
  FSSL := nil;
  FWriteLock := TCriticalSection.Create;
  FHandshakeHeaders := TStringList.Create;
  FOpen := False;
  try
    FRemoteAddr := FSocket.Endpoint.Address.Address;
  except
    FRemoteAddr := '';
  end;
end;

destructor TTina4WSConnection.Destroy;
begin
  FreeAndNil(FReadThread);
  // SSL must be torn down before the socket — Shutdown sends a
  // close_notify alert through the underlying fd.
  FreeAndNil(FSSL);
  CloseSocket;
  FreeAndNil(FHandshakeHeaders);
  FreeAndNil(FWriteLock);
  inherited;
end;

procedure TTina4WSConnection.RawSend(const AData: TBytes);
var
  Sent, Total, Ret: Integer;
begin
  // Serialize writes — a publish from the broker can race a control
  // frame from the read thread, both writing to the same socket.
  FWriteLock.Enter;
  try
    if FSSL <> nil then
    begin
      // TLS path — loop because SSL_write may write less than asked.
      Total := Length(AData);
      Sent := 0;
      while Sent < Total do
      begin
        Ret := FSSL.Write(@AData[Sent], Total - Sent);
        if Ret <= 0 then Exit;  // peer gone or error
        Inc(Sent, Ret);
      end;
    end
    else if FSocket <> nil then
      FSocket.Send(AData);
  finally
    FWriteLock.Leave;
  end;
end;

function TTina4WSConnection.RawRecv(ALen: Integer): TBytes;
var
  Buf: TBytes;
  Got, Want, Ret: Integer;
begin
  SetLength(Result, ALen);
  Got := 0;
  while Got < ALen do
  begin
    Want := ALen - Got;
    if FSSL <> nil then
    begin
      // TLS path — SSL_read returns 0 on close, -1 on error.
      Ret := FSSL.Read(@Result[Got], Want);
      if Ret <= 0 then
      begin
        SetLength(Result, Got);
        Exit;
      end;
      Inc(Got, Ret);
    end
    else
    begin
      // TSocket.Receive is a blocking short read — returns whatever is
      // buffered (possibly less than requested). Loop until we have ALen.
      Buf := FSocket.Receive(Want);
      if Length(Buf) = 0 then
      begin
        // Peer closed or error — truncate and return what we got so the
        // frame reader raises a clean "short read" error.
        SetLength(Result, Got);
        Exit;
      end;
      Move(Buf[0], Result[Got], Length(Buf));
      Inc(Got, Length(Buf));
    end;
  end;
end;

procedure TTina4WSConnection.CloseSocket;
begin
  if FSocket <> nil then
  begin
    try FSocket.Close(True); except end;
    try FSocket.Free; except end;
    FSocket := nil;
  end;
end;

procedure TTina4WSConnection.Send(const AMessage: string);
var
  Frame: TBytes;
begin
  if not FOpen then Exit;
  Frame := EncodeFrame(WS_OP_TEXT, TEncoding.UTF8.GetBytes(AMessage), False);
  RawSend(Frame);
end;

procedure TTina4WSConnection.Send(const AData: TBytes);
var
  Frame: TBytes;
begin
  if not FOpen then Exit;
  Frame := EncodeFrame(WS_OP_BINARY, AData, False);
  RawSend(Frame);
end;

procedure TTina4WSConnection.Close(ACode: Integer; const AReason: string);
var
  Frame: TBytes;
begin
  if not FOpen then Exit;
  try
    Frame := EncodeFrame(WS_OP_CLOSE, BuildClosePayload(ACode, AReason), False);
    RawSend(Frame);
  except
  end;
  FOpen := False;
end;

function TTina4WSConnection.IsOpen: Boolean;
begin
  Result := FOpen;
end;

{ ---- TTina4WebSocketServer ---- }

constructor TTina4WebSocketServer.Create;
begin
  inherited;
  FConnections := TList<TTina4WSConnection>.Create;
  FConnectionsLock := TCriticalSection.Create;
  FRunning := False;
  FSSLCtx := nil;
end;

destructor TTina4WebSocketServer.Destroy;
begin
  Stop;
  FreeAndNil(FSSLCtx);
  FreeAndNil(FConnections);
  FreeAndNil(FConnectionsLock);
  inherited;
end;

function TTina4WebSocketServer.UseCertificate(const ACertFile,
  AKeyFile: string): Boolean;
begin
  // Lazy-create the SSL context on first use; we don't need OpenSSL
  // at all for ws:// servers, so don't pay the load cost up front.
  if FSSLCtx = nil then
    FSSLCtx := TTina4SSLServerContext.Create;
  Result := FSSLCtx.LoadCertificate(ACertFile, AKeyFile);
  if not Result then
    FreeAndNil(FSSLCtx);  // failed load — treat as no-TLS, no half-state
end;

function TTina4WebSocketServer.UsesTLS: Boolean;
begin
  Result := (FSSLCtx <> nil) and FSSLCtx.IsReady;
end;

procedure TTina4WebSocketServer.Listen(APort: Integer; const ABindHost: string);
var
  BindIP: string;
begin
  if FRunning then Exit;
  FPort := APort;
  FBindHost := ABindHost;
  if ABindHost = '' then
    BindIP := '0.0.0.0'
  else
    BindIP := ABindHost;

  FListener := TSocket.Create(TSocketType.TCP);
  // TSocket.Listen overload: Listen(Address, Service, Port, QueueSize).
  // Service '' = no service name lookup; QueueSize -1 = system default.
  FListener.Listen(BindIP, '', Word(APort), -1);
  FRunning := True;

  FAcceptThread := TWSAcceptThread.Create(Self);
  TWSAcceptThread(FAcceptThread).Start;
end;

procedure TTina4WebSocketServer.Stop;
var
  Conns: TArray<TTina4WSConnection>;
  C: TTina4WSConnection;
begin
  if not FRunning then Exit;
  FRunning := False;

  // Closing the listener unblocks the accept thread.
  if FListener <> nil then
  begin
    try FListener.Close(True); except end;
    try FListener.Free; except end;
    FListener := nil;
  end;
  if FAcceptThread <> nil then
  begin
    try FAcceptThread.WaitFor; except end;
    FreeAndNil(FAcceptThread);
  end;

  // Close every live connection — their read threads exit, fire
  // disconnect events, and self-destruct.
  Conns := Snapshot;
  for C in Conns do
  begin
    try C.Close(WS_CLOSE_GOING_AWAY, 'Server shutting down'); except end;
    try C.CloseSocket; except end;  // force the read to error out
  end;

  // Wait briefly for connection threads to drain.
  var Spins := 0;
  while (ClientCount > 0) and (Spins < 50) do
  begin
    Sleep(20);
    Inc(Spins);
  end;
end;

function TTina4WebSocketServer.ClientCount: Integer;
begin
  FConnectionsLock.Enter;
  try
    Result := FConnections.Count;
  finally
    FConnectionsLock.Leave;
  end;
end;

function TTina4WebSocketServer.Snapshot: TArray<TTina4WSConnection>;
begin
  FConnectionsLock.Enter;
  try
    Result := FConnections.ToArray;
  finally
    FConnectionsLock.Leave;
  end;
end;

procedure TTina4WebSocketServer.RegisterConnection(AConn: TTina4WSConnection);
begin
  FConnectionsLock.Enter;
  try
    FConnections.Add(AConn);
  finally
    FConnectionsLock.Leave;
  end;
end;

procedure TTina4WebSocketServer.UnregisterConnection(AConn: TTina4WSConnection);
begin
  FConnectionsLock.Enter;
  try
    FConnections.Remove(AConn);
  finally
    FConnectionsLock.Leave;
  end;
end;

procedure TTina4WebSocketServer.FireConnect(AConn: TTina4WSConnection);
begin
  if Assigned(FOnConnect) then
    try FOnConnect(Self, AConn); except end;
end;

procedure TTina4WebSocketServer.FireDisconnect(AConn: TTina4WSConnection;
  ACode: Integer; const AReason: string);
begin
  if Assigned(FOnDisconnect) then
    try FOnDisconnect(Self, AConn, ACode, AReason); except end;
end;

procedure TTina4WebSocketServer.FireMessage(AConn: TTina4WSConnection;
  const AMsg: string);
begin
  if Assigned(FOnMessage) then
    try FOnMessage(Self, AConn, AMsg); except end;
end;

procedure TTina4WebSocketServer.FireBinary(AConn: TTina4WSConnection;
  const AData: TBytes);
begin
  if Assigned(FOnBinary) then
    try FOnBinary(Self, AConn, AData); except end;
end;

procedure TTina4WebSocketServer.FireError(AConn: TTina4WSConnection;
  const AError: string);
begin
  if Assigned(FOnError) then
    try FOnError(Self, AConn, AError); except end;
end;

end.
