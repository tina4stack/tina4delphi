unit Tina4WebSocketClient;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Net.Socket,
  System.Types, System.NetEncoding, System.Hash, System.DateUtils,
  {$IFDEF POSIX}Posix.NetDB, Posix.SysSocket, Posix.ArpaInet,{$ENDIF}
  Tina4OpenSSL;

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
    FReconnectMaxAttempts: Integer;
    FPingInterval: Integer;
    FConnectTimeout: Integer;
    FState: TTina4WSState;

    FOnConnected: TNotifyEvent;
    FOnDisconnected: TTina4WSDisconnectEvent;
    FOnMessage: TTina4WSMessageEvent;
    FOnBinaryReceived: TTina4WSBinaryEvent;
    FOnError: TTina4WSErrorEvent;
    FOnReconnecting: TTina4WSReconnectEvent;

    FSocket: TSocket;
    FSSL: TTina4SSLContext;
    FUseTLS: Boolean;
    FHost: string;
    FPort: Integer;
    FPath: string;
    FReadThread: TTina4WSReadThread;
    FWriteLock: TCriticalSection;
    FReconnectAttempt: Integer;
    FLastPingSent: TDateTime;
    FPingTimer: TThread;
    FPingWake: TEvent;  // signaled to wake ping thread out of its wait early

    function GetHeaders: TStrings;
    procedure SetHeaders(const Value: TStrings);
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

    // WebSocket frame encode/decode
    function EncodeFrame(AOpcode: Byte; const APayload: TBytes): TBytes;
    procedure ProcessFrame(AOpcode: Byte; const APayload: TBytes);
    function GenerateMaskKey: TBytes;

    // Event dispatchers (queue to main thread)
    procedure FireConnected;
    procedure FireDisconnected(ACode: Integer; const AReason: string);
    procedure FireMessage(const AMsg: string);
    procedure FireBinary(const AData: TBytes);
    procedure FireError(const AError: string);
    procedure FireReconnecting(AAttempt: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    /// <summary>Connect to the WebSocket server</summary>
    procedure Connect;
    /// <summary>Disconnect gracefully</summary>
    procedure Disconnect;
    /// <summary>Send a text message</summary>
    procedure Send(const AMessage: string); overload;
    /// <summary>Send binary data</summary>
    procedure Send(const AData: TBytes); overload;
    /// <summary>True if the connection is open</summary>
    function IsConnected: Boolean;
    /// <summary>Current connection state</summary>
    property State: TTina4WSState read FState;
  published
    /// <summary>WebSocket URL (ws:// or wss://)</summary>
    property URL: string read FURL write FURL;
    /// <summary>Custom HTTP headers (one per line, Name: Value format)</summary>
    property Headers: TStrings read GetHeaders write SetHeaders;
    /// <summary>Auto-reconnect on unexpected disconnect (default True)</summary>
    property AutoReconnect: Boolean read FAutoReconnect write FAutoReconnect
      default True;
    /// <summary>Delay between reconnect attempts in ms (default 3000)</summary>
    property ReconnectInterval: Integer read FReconnectInterval
      write FReconnectInterval default 3000;
    /// <summary>Max reconnect attempts. 0 = infinite (default 10)</summary>
    property ReconnectMaxAttempts: Integer read FReconnectMaxAttempts
      write FReconnectMaxAttempts default 10;
    /// <summary>Ping interval in ms. 0 = disabled (default 30000)</summary>
    property PingInterval: Integer read FPingInterval write FPingInterval
      default 30000;
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
  end;

procedure Register;

implementation

{$IFDEF MSWINDOWS}
uses
  Winapi.Windows;
{$ENDIF}

{ WebSocket opcodes }
const
  WS_OP_CONTINUATION = $00;
  WS_OP_TEXT         = $01;
  WS_OP_BINARY       = $02;
  WS_OP_CLOSE        = $08;
  WS_OP_PING         = $09;
  WS_OP_PONG         = $0A;

  WS_FIN_BIT         = $80;
  WS_MASK_BIT        = $80;

  WS_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';

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
  B0, B1: Byte;
  Opcode, FinalOpcode: Byte;
  Fin: Boolean;
  PayloadLen: UInt64;
  MaskKey: TBytes;
  Masked: Boolean;
  FramePayload: TBytes;
  MessageBuf: TBytes;
  I: Integer;
  TempBytes: TBytes;
begin
  MessageBuf := nil;
  FinalOpcode := 0;

  while not Terminated and (FOwner.FState = wsOpen) do
  begin
    try
      // Read first 2 bytes of frame header
      B0 := FOwner.RawRecvByte;
      B1 := FOwner.RawRecvByte;

      Fin := (B0 and WS_FIN_BIT) <> 0;
      Opcode := B0 and $0F;
      Masked := (B1 and WS_MASK_BIT) <> 0;
      PayloadLen := B1 and $7F;

      // Extended payload length
      if PayloadLen = 126 then
      begin
        TempBytes := FOwner.RawRecv(2);
        PayloadLen := (UInt64(TempBytes[0]) shl 8) or UInt64(TempBytes[1]);
      end
      else if PayloadLen = 127 then
      begin
        TempBytes := FOwner.RawRecv(8);
        PayloadLen := 0;
        for I := 0 to 7 do
          PayloadLen := (PayloadLen shl 8) or UInt64(TempBytes[I]);
      end;

      // Masking key (server should not mask, but handle it)
      if Masked then
        MaskKey := FOwner.RawRecv(4)
      else
        MaskKey := nil;

      // Read payload
      if PayloadLen > 0 then
      begin
        FramePayload := FOwner.RawRecv(Integer(PayloadLen));

        // Unmask if needed
        if Masked and (Length(MaskKey) = 4) then
          for I := 0 to Length(FramePayload) - 1 do
            FramePayload[I] := FramePayload[I] xor MaskKey[I mod 4];
      end
      else
        FramePayload := nil;

      // Handle control frames immediately (they can interleave data frames)
      if Opcode >= $08 then
      begin
        FOwner.ProcessFrame(Opcode, FramePayload);
        Continue;
      end;

      // Data frame: accumulate fragments
      if Opcode <> WS_OP_CONTINUATION then
      begin
        // Start of new message
        FinalOpcode := Opcode;
        MessageBuf := FramePayload;
      end
      else
      begin
        // Continuation frame — append
        if (MessageBuf <> nil) and (FramePayload <> nil) then
        begin
          var OldLen := Length(MessageBuf);
          SetLength(MessageBuf, OldLen + Length(FramePayload));
          Move(FramePayload[0], MessageBuf[OldLen], Length(FramePayload));
        end;
      end;

      if Fin then
      begin
        FOwner.ProcessFrame(FinalOpcode, MessageBuf);
        MessageBuf := nil;
        FinalOpcode := 0;
      end;

    except
      on E: Exception do
      begin
        if not Terminated and (FOwner.FState = wsOpen) then
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
  FPingWake := TEvent.Create(nil, True, False, '');  // manual-reset, initially non-signaled
  FAutoReconnect := True;
  FReconnectInterval := 3000;
  FReconnectMaxAttempts := 10;
  FPingInterval := 30000;
  FConnectTimeout := 5000;
  FState := wsClosed;
  FReconnectAttempt := 0;
end;

destructor TTina4WebSocketClient.Destroy;
begin
  FAutoReconnect := False; // prevent reconnect during teardown
  Disconnect;
  FPingWake.Free;
  FWriteLock.Free;
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
  if FState in [wsOpen, wsConnecting] then
    Exit;

  FReconnectAttempt := 0;
  DoConnect;
end;

procedure TTina4WebSocketClient.DoConnect;
begin
  FState := wsConnecting;

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

        // Connection succeeded
        FState := wsOpen;
        FReconnectAttempt := 0;
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
          if Assigned(FSocket) then
          begin
            try
              FSocket.Close(True);
            except
            end;
            FreeAndNil(FSocket);
          end;
          FState := wsClosed;

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
  FWriteLock.Enter;
  try
    Total := Length(AData);
    Sent := 0;
    while Sent < Total do
    begin
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

function TTina4WebSocketClient.GenerateMaskKey: TBytes;
begin
  SetLength(Result, 4);
  Result[0] := Byte(Random(256));
  Result[1] := Byte(Random(256));
  Result[2] := Byte(Random(256));
  Result[3] := Byte(Random(256));
end;

function TTina4WebSocketClient.EncodeFrame(AOpcode: Byte;
  const APayload: TBytes): TBytes;
var
  Header: TBytes;
  MaskKey: TBytes;
  PayloadLen: Int64;
  I, Offset: Integer;
begin
  PayloadLen := Length(APayload);
  MaskKey := GenerateMaskKey;

  // Calculate header size
  if PayloadLen <= 125 then
    SetLength(Header, 2)
  else if PayloadLen <= 65535 then
    SetLength(Header, 4)
  else
    SetLength(Header, 10);

  // FIN + opcode
  Header[0] := WS_FIN_BIT or AOpcode;

  // Payload length + mask bit (client MUST mask)
  if PayloadLen <= 125 then
    Header[1] := WS_MASK_BIT or Byte(PayloadLen)
  else if PayloadLen <= 65535 then
  begin
    Header[1] := WS_MASK_BIT or 126;
    Header[2] := Byte(PayloadLen shr 8);
    Header[3] := Byte(PayloadLen);
  end
  else
  begin
    Header[1] := WS_MASK_BIT or 127;
    for I := 0 to 7 do
      Header[2 + I] := Byte(PayloadLen shr ((7 - I) * 8));
  end;

  // Build complete frame: header + mask key + masked payload
  SetLength(Result, Length(Header) + 4 + Length(APayload));
  Move(Header[0], Result[0], Length(Header));
  Move(MaskKey[0], Result[Length(Header)], 4);

  Offset := Length(Header) + 4;
  for I := 0 to Length(APayload) - 1 do
    Result[Offset + I] := APayload[I] xor MaskKey[I mod 4];
end;

{ ---- Frame Processing ---- }

procedure TTina4WebSocketClient.ProcessFrame(AOpcode: Byte;
  const APayload: TBytes);
var
  CloseCode: Integer;
  CloseReason: string;
  PongFrame: TBytes;
begin
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
      ; // Pong received — we could track latency, but just ignore

    WS_OP_CLOSE:
      begin
        // Parse close code and reason
        CloseCode := 1000;
        CloseReason := '';
        if (APayload <> nil) and (Length(APayload) >= 2) then
        begin
          CloseCode := (Integer(APayload[0]) shl 8) or Integer(APayload[1]);
          if Length(APayload) > 2 then
          begin
            var ReasonBytes: TBytes;
            SetLength(ReasonBytes, Length(APayload) - 2);
            Move(APayload[2], ReasonBytes[0], Length(ReasonBytes));
            CloseReason := TEncoding.UTF8.GetString(ReasonBytes);
          end;
        end;

        // Echo close frame back if we haven't sent one yet
        if FState = wsOpen then
        begin
          FState := wsClosing;
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
  if FState <> wsOpen then
    raise Exception.Create('WebSocket is not connected');

  Payload := TEncoding.UTF8.GetBytes(AMessage);
  Frame := EncodeFrame(WS_OP_TEXT, Payload);
  RawSend(Frame);
end;

procedure TTina4WebSocketClient.Send(const AData: TBytes);
var
  Frame: TBytes;
begin
  if FState <> wsOpen then
    raise Exception.Create('WebSocket is not connected');

  Frame := EncodeFrame(WS_OP_BINARY, AData);
  RawSend(Frame);
end;

{ ---- Disconnect ---- }

procedure TTina4WebSocketClient.Disconnect;
var
  ClosePayload, Frame: TBytes;
begin
  FAutoReconnect := False; // explicit disconnect = no reconnect
  StopPingTimer;

  if FState = wsOpen then
  begin
    FState := wsClosing;

    // Send close frame (code 1000 = normal closure)
    SetLength(ClosePayload, 2);
    ClosePayload[0] := Byte(1000 shr 8);
    ClosePayload[1] := Byte(1000);
    try
      Frame := EncodeFrame(WS_OP_CLOSE, ClosePayload);
      RawSend(Frame);
    except
    end;

    DoDisconnectInternal(1000, 'Normal closure', False);
  end
  else if FState in [wsConnecting, wsReconnecting] then
  begin
    DoDisconnectInternal(1000, 'Cancelled', False);
  end;
end;

procedure TTina4WebSocketClient.DoDisconnectInternal(ACode: Integer;
  const AReason: string; AStartReconnect: Boolean);
var
  CalledFromReader: Boolean;
begin
  // If the read thread itself triggered this (e.g. server dropped the
  // connection), we cannot WaitFor it from inside itself — that would
  // deadlock. Detect and skip the join; the reader will free itself.
  CalledFromReader := Assigned(FReadThread) and
                      (TThread.CurrentThread.ThreadID = FReadThread.ThreadID);

  StopPingTimer;

  // Signal the read thread to stop. We must close the socket BEFORE WaitFor —
  // the read thread is blocked in a kernel recv() with no timeout and will not
  // wake up until either data arrives or the socket is shut down. Closing
  // here causes recv to return immediately with an error, the thread catches
  // the exception and exits, and our WaitFor returns in milliseconds instead
  // of waiting for the OS-level TCP timeout (which can be minutes).
  if Assigned(FReadThread) then
    FReadThread.Terminate;

  // Shut down TLS first so any in-progress SSL_read returns immediately
  if Assigned(FSSL) then
  begin
    try
      FSSL.Shutdown;
    except
    end;
  end;

  // Close the underlying socket — this is what unblocks the read thread
  if Assigned(FSocket) then
  begin
    try
      FSocket.Close(True);
    except
    end;
  end;

  // Now safe to wait for the read thread — it will exit promptly
  if Assigned(FReadThread) and not CalledFromReader then
  begin
    FReadThread.WaitFor;
    FreeAndNil(FReadThread);
  end
  else if CalledFromReader then
  begin
    // Reader is unwinding itself — let it free on exit and just drop our ref
    FReadThread.FreeOnTerminate := True;
    FReadThread := nil;
  end;

  // Free TLS context after the reader has stopped touching it
  if Assigned(FSSL) then
    FreeAndNil(FSSL);

  // Free the socket object
  if Assigned(FSocket) then
    FreeAndNil(FSocket);

  FState := wsClosed;
  FireDisconnected(ACode, AReason);

  // Auto-reconnect on unexpected disconnect
  if AStartReconnect and FAutoReconnect then
    DoReconnect;
end;

{ ---- Reconnect ---- }

procedure TTina4WebSocketClient.DoReconnect;
begin
  if not FAutoReconnect then
    Exit;

  Inc(FReconnectAttempt);

  if (FReconnectMaxAttempts > 0) and
     (FReconnectAttempt > FReconnectMaxAttempts) then
  begin
    FireError('Max reconnect attempts (' +
      IntToStr(FReconnectMaxAttempts) + ') exceeded');
    FState := wsClosed;
    Exit;
  end;

  FState := wsReconnecting;
  FireReconnecting(FReconnectAttempt);

  // Wait then reconnect in a background thread
  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(FReconnectInterval);
      if FAutoReconnect and (FState = wsReconnecting) then
        DoConnect;
    end
  ).Start;
end;

{ ---- Ping Timer ---- }

procedure TTina4WebSocketClient.StartPingTimer;
begin
  StopPingTimer;
  if FPingInterval <= 0 then
    Exit;

  FPingWake.ResetEvent;

  FPingTimer := TThread.CreateAnonymousThread(
    procedure
    var
      PingFrame: TBytes;
    begin
      while not TThread.Current.CheckTerminated and (FState = wsOpen) do
      begin
        // Wait up to FPingInterval ms — wakes immediately if FPingWake is signaled
        if FPingWake.WaitFor(FPingInterval) = wrSignaled then
          Break;
        if TThread.Current.CheckTerminated or (FState <> wsOpen) then
          Break;
        try
          PingFrame := EncodeFrame(WS_OP_PING, nil);
          RawSend(PingFrame);
          FLastPingSent := Now;
        except
          Break;
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
    TThread.Queue(TThread(nil),
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
    TThread.Queue(TThread(nil),
      procedure
      begin
        if Assigned(FOnDisconnected) then
          FOnDisconnected(Self, ACode, AReason);
      end);
end;

procedure TTina4WebSocketClient.FireMessage(const AMsg: string);
begin
  if Assigned(FOnMessage) then
    TThread.Queue(TThread(nil),
      procedure
      begin
        if Assigned(FOnMessage) then
          FOnMessage(Self, AMsg);
      end);
end;

procedure TTina4WebSocketClient.FireBinary(const AData: TBytes);
begin
  if Assigned(FOnBinaryReceived) then
    TThread.Queue(TThread(nil),
      procedure
      begin
        if Assigned(FOnBinaryReceived) then
          FOnBinaryReceived(Self, AData);
      end);
end;

procedure TTina4WebSocketClient.FireError(const AError: string);
begin
  if Assigned(FOnError) then
    TThread.Queue(TThread(nil),
      procedure
      begin
        if Assigned(FOnError) then
          FOnError(Self, AError);
      end);
end;

procedure TTina4WebSocketClient.FireReconnecting(AAttempt: Integer);
begin
  if Assigned(FOnReconnecting) then
    TThread.Queue(TThread(nil),
      procedure
      begin
        if Assigned(FOnReconnecting) then
          FOnReconnecting(Self, AAttempt);
      end);
end;

function TTina4WebSocketClient.IsConnected: Boolean;
begin
  Result := FState = wsOpen;
end;

initialization
  Randomize;

end.
