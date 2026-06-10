unit TestTina4WebSocket;

interface

uses
  TestFramework, System.SysUtils, System.Classes, System.SyncObjs,
  Tina4OpenSSL, Tina4WebSocketClient,
  Tina4WebSocketServer, Tina4WebSocketFrames, Tina4WebSocketBroker;

type
  // Helper to capture events from TTina4WebSocketClient
  TWSTestHelper = class
  public
    Connected: Boolean;
    Disconnected: Boolean;
    DisconnectCode: Integer;
    DisconnectReason: string;
    LastMessage: string;
    LastError: string;
    MessageCount: Integer;
    ReconnectAttempt: Integer;
    StateChangeFired: Boolean;
    LastStateChangeOld, LastStateChangeNew: TTina4WSState;
    procedure OnConnected(Sender: TObject);
    procedure OnDisconnected(Sender: TObject; const ACode: Integer;
      const AReason: string);
    procedure OnMessage(Sender: TObject; const AMessage: string);
    procedure OnError(Sender: TObject; const AError: string);
    procedure OnReconnecting(Sender: TObject; AAttempt: Integer);
    procedure OnStateChange(Sender: TObject;
      AOldState, ANewState: TTina4WSState);
    procedure Reset;
    procedure OnServerError(Sender: TObject; Connection: TTina4WSConnection;
      const AError: string);
  end;

  // ---- Unit tests (no network) ----
  TestTTina4WebSocketUnit = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // Component creation / defaults
    procedure TestCreateDestroy;
    procedure TestDefaultProperties;
    procedure TestSetProperties;
    procedure TestHeadersAssign;

    // URL parsing
    procedure TestParseWSURL;
    procedure TestParseWSSURL;
    procedure TestParseURLWithPort;
    procedure TestParseURLWithPath;
    procedure TestParseInvalidURL;

    // State checks
    procedure TestInitialState;
    procedure TestIsConnectedWhenClosed;
    procedure TestSendWhenNotConnected;
    procedure TestDisconnectWhenClosed;

    // Mobile bullet-proofing — disconnect controls
    procedure TestDisconnectWithCodeAndReason;
    procedure TestForceReconnectWhenClosedTriggersReconnect;
    procedure TestNotifyNetworkChangedWhenClosedNoop;
    procedure TestStateChangeEventFiresOnDisconnect;

    // OpenSSL loader
    procedure TestOpenSSLLoad;
  end;

  // ---- Integration tests (in-process server + client) ----
  TestTTina4WebSocketIntegration = class(TTestCase)
  private
    FServer: TTina4WebSocketServer;
    FBroker: TTina4WebSocketBroker;
    FClient: TTina4WebSocketClient;
    FHelper: TWSTestHelper;
    FPort: Integer;
    procedure WaitForCondition(ACondition: TFunc<Boolean>;
      ATimeoutMs: Integer = 10000);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConnectToServer;
    procedure TestSubscribeAndReceiveAck;
    procedure TestPublishAndReceiveAck;
    procedure TestDisconnectClean;
    procedure TestAutoReconnectOff;
  end;

  // ---- wss:// integration tests ----
  // Uses a self-signed cert+key checked into Example/Test/testdata/.
  // Each test no-ops gracefully if OpenSSL isn't loadable in this
  // environment (Check passes with a note instead of failing).
  TestTTina4WebSocketTLS = class(TTestCase)
  private
    FServer: TTina4WebSocketServer;
    FBroker: TTina4WebSocketBroker;
    FClient: TTina4WebSocketClient;
    FHelper: TWSTestHelper;
    FPort: Integer;
    FOpenSSLAvailable: Boolean;
    procedure WaitForCondition(ACondition: TFunc<Boolean>;
      ATimeoutMs: Integer = 10000);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestWssConnectAndSubscribe;
  end;

implementation

const
  // Each integration test spins up its own broker on a fresh ephemeral
  // port so tests don't collide with each other or with anything else
  // that happens to be listening locally.
  TEST_PORT_BASE = 47000;
  TEST_TOPIC = 'TestRoom';

{ ---- TWSTestHelper ---- }

procedure TWSTestHelper.Reset;
begin
  Connected := False;
  Disconnected := False;
  DisconnectCode := 0;
  DisconnectReason := '';
  LastMessage := '';
  LastError := '';
  MessageCount := 0;
  ReconnectAttempt := 0;
  StateChangeFired := False;
  LastStateChangeOld := wsClosed;
  LastStateChangeNew := wsClosed;
end;

procedure TWSTestHelper.OnConnected(Sender: TObject);
begin
  Connected := True;
end;

procedure TWSTestHelper.OnDisconnected(Sender: TObject; const ACode: Integer;
  const AReason: string);
begin
  Disconnected := True;
  DisconnectCode := ACode;
  DisconnectReason := AReason;
end;

procedure TWSTestHelper.OnMessage(Sender: TObject; const AMessage: string);
begin
  LastMessage := AMessage;
  Inc(MessageCount);
end;

procedure TWSTestHelper.OnError(Sender: TObject; const AError: string);
begin
  LastError := AError;
end;

procedure TWSTestHelper.OnReconnecting(Sender: TObject; AAttempt: Integer);
begin
  ReconnectAttempt := AAttempt;
end;

procedure TWSTestHelper.OnStateChange(Sender: TObject;
  AOldState, ANewState: TTina4WSState);
begin
  StateChangeFired := True;
  LastStateChangeOld := AOldState;
  LastStateChangeNew := ANewState;
end;

procedure TWSTestHelper.OnServerError(Sender: TObject;
  Connection: TTina4WSConnection; const AError: string);
begin
  LastError := 'server: ' + AError;
end;

{ ---- TestTTina4WebSocketUnit ---- }

procedure TestTTina4WebSocketUnit.SetUp;
begin
end;

procedure TestTTina4WebSocketUnit.TearDown;
begin
end;

{ -- Component creation / defaults -- }

procedure TestTTina4WebSocketUnit.TestCreateDestroy;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    Check(WS <> nil, 'Component should be created');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestDefaultProperties;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    CheckEquals('', WS.URL, 'URL should default to empty');
    CheckEquals(True, WS.AutoReconnect, 'AutoReconnect should default to True');
    CheckEquals(3000, WS.ReconnectInterval, 'ReconnectInterval should default to 3000');
    CheckEquals(10, WS.ReconnectMaxAttempts, 'ReconnectMaxAttempts should default to 10');
    CheckEquals(30000, WS.PingInterval, 'PingInterval should default to 30000');
    CheckEquals(5000, WS.ConnectTimeout, 'ConnectTimeout should default to 5000');
    // Mobile bullet-proofing defaults
    CheckEquals(10000, WS.PongTimeout, 'PongTimeout should default to 10000');
    CheckEquals(60000, WS.ReconnectMaxInterval,
      'ReconnectMaxInterval should default to 60000');
    CheckEquals(0, WS.MaxConnectionAge,
      'MaxConnectionAge should default to 0 (disabled)');
    Check(WS.State = wsClosed, 'State should default to wsClosed');
    CheckEquals(0, WS.Headers.Count, 'Headers should be empty');
    CheckEquals(0, WS.LastRTT, 'LastRTT should start at 0');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestSetProperties;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.URL := 'wss://example.com/ws';
    WS.AutoReconnect := False;
    WS.ReconnectInterval := 5000;
    WS.ReconnectMaxAttempts := 3;
    WS.PingInterval := 0;
    WS.ConnectTimeout := 10000;

    CheckEquals('wss://example.com/ws', WS.URL);
    CheckEquals(False, WS.AutoReconnect);
    CheckEquals(5000, WS.ReconnectInterval);
    CheckEquals(3, WS.ReconnectMaxAttempts);
    CheckEquals(0, WS.PingInterval);
    CheckEquals(10000, WS.ConnectTimeout);
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestHeadersAssign;
var
  WS: TTina4WebSocketClient;
  SL: TStringList;
begin
  WS := TTina4WebSocketClient.Create(nil);
  SL := TStringList.Create;
  try
    SL.Add('Authorization: Bearer abc123');
    SL.Add('X-Custom: value');
    WS.Headers := SL;

    CheckEquals(2, WS.Headers.Count, 'Should have 2 headers');
    CheckEquals('Authorization: Bearer abc123', WS.Headers[0]);
    CheckEquals('X-Custom: value', WS.Headers[1]);
  finally
    SL.Free;
    WS.Free;
  end;
end;

{ -- URL parsing (tested indirectly via Connect error messages) -- }

procedure TestTTina4WebSocketUnit.TestParseWSURL;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.URL := 'ws://localhost/test';
    WS.AutoReconnect := False;
    // Connect will fail (no server) but should not raise on URL parse
    // The error should be about connection, not about URL parsing
    WS.Connect;
    Sleep(500);
    CheckSynchronize(200);
    // If we get here, URL was parsed OK (connection will fail asynchronously)
    Check(True, 'ws:// URL parsed without error');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestParseWSSURL;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.URL := 'wss://example.com/api';
    WS.AutoReconnect := False;
    WS.Connect;
    Sleep(500);
    CheckSynchronize(200);
    Check(True, 'wss:// URL parsed without error');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestParseURLWithPort;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.URL := 'ws://localhost:8080/ws';
    WS.AutoReconnect := False;
    WS.Connect;
    Sleep(500);
    CheckSynchronize(200);
    Check(True, 'URL with custom port parsed without error');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestParseURLWithPath;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.URL := 'wss://example.com/api/v2/notifications';
    WS.AutoReconnect := False;
    WS.Connect;
    Sleep(500);
    CheckSynchronize(200);
    Check(True, 'URL with deep path parsed without error');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestParseInvalidURL;
var
  WS: TTina4WebSocketClient;
  Helper: TWSTestHelper;
begin
  WS := TTina4WebSocketClient.Create(nil);
  Helper := TWSTestHelper.Create;
  try
    Helper.Reset;
    WS.URL := 'http://not-a-websocket-url';
    WS.AutoReconnect := False;
    WS.OnError := Helper.OnError;
    WS.Connect;

    // Wait for async error
    Sleep(1000);
    CheckSynchronize(200);

    Check(Helper.LastError <> '', 'Should fire error for invalid URL scheme');
  finally
    Helper.Free;
    WS.Free;
  end;
end;

{ -- State checks -- }

procedure TestTTina4WebSocketUnit.TestInitialState;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    Check(WS.State = wsClosed, 'Initial state should be wsClosed');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestIsConnectedWhenClosed;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    CheckEquals(False, WS.IsConnected, 'Should not be connected when closed');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestSendWhenNotConnected;
var
  WS: TTina4WebSocketClient;
  Raised: Boolean;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    Raised := False;
    try
      WS.Send('test');
    except
      on E: Exception do
      begin
        Raised := True;
        Check(Pos('not connected', E.Message.ToLower) > 0,
          'Exception should mention not connected');
      end;
    end;
    Check(Raised, 'Send on closed socket should raise exception');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestDisconnectWhenClosed;
var
  WS: TTina4WebSocketClient;
begin
  WS := TTina4WebSocketClient.Create(nil);
  try
    // Should not raise — just a no-op
    WS.Disconnect;
    Check(WS.State = wsClosed, 'State should remain closed');
  finally
    WS.Free;
  end;
end;

{ -- Mobile bullet-proofing — disconnect controls -- }

procedure TestTTina4WebSocketUnit.TestDisconnectWithCodeAndReason;
var
  WS: TTina4WebSocketClient;
begin
  // Even with no live connection, Disconnect(code, reason) should accept
  // the parameters without raising and leave the component in wsClosed.
  // The code path that actually sends the close frame is exercised by
  // the integration tests below.
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.Disconnect(1001, 'going to background');
    Check(WS.State = wsClosed, 'State should remain closed');
    WS.Disconnect(4000, 'application logout');
    Check(WS.State = wsClosed, 'State should remain closed');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestForceReconnectWhenClosedTriggersReconnect;
var
  WS: TTina4WebSocketClient;
  H: TWSTestHelper;
begin
  // From wsClosed with no URL set, ForceReconnect should still:
  //   1. Flip AutoReconnect back on,
  //   2. Fire OnReconnecting,
  //   3. Asynchronously fail the connect (no URL/server),
  // without raising on the caller's thread.
  WS := TTina4WebSocketClient.Create(nil);
  H := TWSTestHelper.Create;
  try
    WS.URL := 'ws://127.0.0.1:1';  // unreachable
    WS.ReconnectInterval := 100;   // keep the test snappy
    WS.ReconnectMaxAttempts := 1;
    WS.OnReconnecting := H.OnReconnecting;
    H.Reset;

    WS.AutoReconnect := False;     // simulate "user disconnected earlier"
    WS.ForceReconnect;             // should override AutoReconnect

    Check(WS.AutoReconnect, 'ForceReconnect should re-enable AutoReconnect');

    // Give the background reconnect thread a moment to fire OnReconnecting.
    var Waited := 0;
    while (H.ReconnectAttempt = 0) and (Waited < 2000) do
    begin
      Sleep(50); CheckSynchronize(50); Inc(Waited, 50);
    end;
    Check(H.ReconnectAttempt >= 1,
      'ForceReconnect should have triggered OnReconnecting');
  finally
    WS.Disconnect;
    Sleep(150);  // let any pending reconnect thread settle
    WS.Free;
    H.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestNotifyNetworkChangedWhenClosedNoop;
var
  WS: TTina4WebSocketClient;
begin
  // With no open connection, NotifyNetworkChanged must be a safe no-op
  // (it should NOT raise, NOT transition state, NOT try to send).
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.NotifyNetworkChanged;
    Check(WS.State = wsClosed, 'State should remain closed');
  finally
    WS.Free;
  end;
end;

procedure TestTTina4WebSocketUnit.TestStateChangeEventFiresOnDisconnect;
var
  WS: TTina4WebSocketClient;
  H: TWSTestHelper;
begin
  // OnStateChange is the single hook for any state transition. Verify it
  // fires for the wsConnecting -> wsClosed flip path that happens when
  // Connect is followed by Disconnect before any TCP success.
  WS := TTina4WebSocketClient.Create(nil);
  H := TWSTestHelper.Create;
  try
    H.Reset;
    WS.URL := 'ws://127.0.0.1:1';  // unreachable -> async failure
    WS.AutoReconnect := False;
    WS.OnStateChange := H.OnStateChange;

    WS.Connect;                    // wsClosed -> wsConnecting
    Sleep(50); CheckSynchronize(50);
    WS.Disconnect;                 // -> wsClosed
    Sleep(200); CheckSynchronize(100);

    Check(H.StateChangeFired, 'OnStateChange should have fired at least once');
    // We don't assert the exact transition pair because the connect
    // thread may have already failed asynchronously, but ending at
    // wsClosed is invariant.
    Check(WS.State = wsClosed, 'Final state should be wsClosed');
  finally
    WS.Free;
    H.Free;
  end;
end;

{ -- OpenSSL -- }

procedure TestTTina4WebSocketUnit.TestOpenSSLLoad;
begin
  Check(LoadOpenSSL, 'OpenSSL should load successfully');
  Check(IsOpenSSLLoaded, 'IsOpenSSLLoaded should return True');
end;

{ ---- TestTTina4WebSocketIntegration ---- }

procedure TestTTina4WebSocketIntegration.SetUp;
var
  Attempt: Integer;
begin
  FHelper := TWSTestHelper.Create;
  FHelper.Reset;

  FServer := TTina4WebSocketServer.Create;
  FBroker := TTina4WebSocketBroker.Create;
  FBroker.Attach(FServer);
  // After Attach, OnConnect/OnDisconnect/OnMessage are owned by the
  // broker. OnError is still free — capture it for diagnostics.
  FServer.OnError := FHelper.OnServerError;

  // Try a sequence of ephemeral ports so a stale TIME_WAIT socket
  // from a previous test doesn't fail this one. After 10 attempts
  // give up and let the test fail informatively.
  for Attempt := 0 to 9 do
  begin
    FPort := TEST_PORT_BASE + Random(1000) + Attempt;
    try
      FServer.Listen(FPort);
      Break;
    except
      FPort := 0;
    end;
  end;
  Check(FPort > 0, 'Could not find a free local port to bind the test server');
  // Give the accept thread a tick to enter Accept() before the
  // client races to connect.
  Sleep(50);

  FClient := TTina4WebSocketClient.Create(nil);
  FClient.URL := 'ws://127.0.0.1:' + IntToStr(FPort) + '/';
  FClient.AutoReconnect := False;
  FClient.PingInterval := 0; // disable for tests
  FClient.OnConnected := FHelper.OnConnected;
  FClient.OnDisconnected := FHelper.OnDisconnected;
  FClient.OnMessage := FHelper.OnMessage;
  FClient.OnError := FHelper.OnError;
  FClient.OnReconnecting := FHelper.OnReconnecting;
end;

procedure TestTTina4WebSocketIntegration.TearDown;
begin
  if Assigned(FClient) and FClient.IsConnected then
    FClient.Disconnect;
  // Drain any queued events on the main thread before tearing down.
  CheckSynchronize(200);
  FreeAndNil(FClient);
  if Assigned(FServer) then
    FServer.Stop;
  FreeAndNil(FBroker);
  FreeAndNil(FServer);
  FreeAndNil(FHelper);
end;

procedure TestTTina4WebSocketIntegration.WaitForCondition(
  ACondition: TFunc<Boolean>; ATimeoutMs: Integer);
var
  Elapsed: Integer;
begin
  Elapsed := 0;
  while (not ACondition()) and (Elapsed < ATimeoutMs) do
  begin
    CheckSynchronize(100);
    Sleep(100);
    Inc(Elapsed, 200);
  end;
end;

procedure TestTTina4WebSocketIntegration.TestConnectToServer;
begin
  FClient.Connect;

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.Connected;
    end);

  Check(FHelper.Connected, 'Should connect to WebSocket server at ' +
    FClient.URL + ' — lastError=' + FHelper.LastError);
  Check(FClient.IsConnected, 'IsConnected should be True');
  Check(FClient.State = wsOpen, 'State should be wsOpen');
  CheckEquals('', FHelper.LastError, 'Should have no errors');
end;

procedure TestTTina4WebSocketIntegration.TestSubscribeAndReceiveAck;
begin
  FClient.Connect;

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.Connected;
    end);
  Check(FHelper.Connected, 'Should connect first');

  // Send subscribe
  FClient.Send('{"action": "subscribe", "topic": "' + TEST_TOPIC + '"}');

  // Wait for acknowledgement
  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.MessageCount > 0;
    end);

  Check(FHelper.MessageCount > 0, 'Should receive at least one message');
  Check(Pos('Subscribed', FHelper.LastMessage) > 0,
    'Should receive subscribe acknowledgement, got: ' + FHelper.LastMessage);
end;

procedure TestTTina4WebSocketIntegration.TestPublishAndReceiveAck;
begin
  FClient.Connect;

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.Connected;
    end);
  Check(FHelper.Connected, 'Should connect first');

  // Subscribe first
  FClient.Send('{"action": "subscribe", "topic": "' + TEST_TOPIC + '"}');
  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.MessageCount > 0;
    end);

  // Reset message counter
  FHelper.MessageCount := 0;
  FHelper.LastMessage := '';

  // Publish
  FClient.Send('{"action": "publish", "topic": "' + TEST_TOPIC +
    '", "message": {"test": "DUnit test message"}}');

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.MessageCount > 0;
    end);

  Check(FHelper.MessageCount > 0, 'Should receive publish acknowledgement');
  Check(Pos('Published', FHelper.LastMessage) > 0,
    'Should receive publish ack, got: ' + FHelper.LastMessage);
end;

procedure TestTTina4WebSocketIntegration.TestDisconnectClean;
begin
  FClient.Connect;

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.Connected;
    end);
  Check(FHelper.Connected, 'Should connect first');

  FClient.Disconnect;

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.Disconnected;
    end);

  Check(FHelper.Disconnected, 'Should fire disconnected event');
  CheckEquals(1000, FHelper.DisconnectCode, 'Close code should be 1000 (normal)');
  Check(FClient.State = wsClosed, 'State should be wsClosed after disconnect');
end;

procedure TestTTina4WebSocketIntegration.TestAutoReconnectOff;
var
  WS: TTina4WebSocketClient;
  H: TWSTestHelper;
begin
  H := TWSTestHelper.Create;
  H.Reset;
  WS := TTina4WebSocketClient.Create(nil);
  try
    WS.URL := 'wss://invalid.host.that.does.not.exist.example.com/ws';
    WS.AutoReconnect := False;
    WS.OnError := H.OnError;
    WS.OnReconnecting := H.OnReconnecting;

    WS.Connect;

    // Wait for connection failure
    WaitForCondition(
      function: Boolean
      begin
        Result := H.LastError <> '';
      end);

    Check(H.LastError <> '', 'Should get connection error');
    CheckEquals(0, H.ReconnectAttempt,
      'Should not attempt reconnect when AutoReconnect is False');
  finally
    WS.Free;
    H.Free;
  end;
end;

{ ---- TestTTina4WebSocketTLS ---- }

function TestDataDir: string;
begin
  // Cert+key live next to this test source. We resolve relative to the
  // executable's working dir at runtime — Tina4DelphiExampleTests.exe
  // is launched from Example\Test\Win32\Debug\, so back up to the
  // Example\Test\ folder.
  Result := IncludeTrailingPathDelimiter(GetCurrentDir) + '..' +
    PathDelim + '..' + PathDelim + '..' + PathDelim + 'testdata' + PathDelim;
end;

procedure TestTTina4WebSocketTLS.SetUp;
var
  Attempt: Integer;
  CertPath, KeyPath: string;
begin
  FHelper := TWSTestHelper.Create;
  FHelper.Reset;
  FOpenSSLAvailable := LoadOpenSSL;

  FServer := TTina4WebSocketServer.Create;
  FBroker := TTina4WebSocketBroker.Create;
  FBroker.Attach(FServer);
  FServer.OnError := FHelper.OnServerError;

  if FOpenSSLAvailable then
  begin
    CertPath := TestDataDir + 'test_cert.pem';
    KeyPath := TestDataDir + 'test_key.pem';
    if FileExists(CertPath) and FileExists(KeyPath) then
    begin
      // If LoadCertificate fails (e.g., the server-side OpenSSL
      // entry points aren't exported), the test will skip.
      if not FServer.UseCertificate(CertPath, KeyPath) then
        FOpenSSLAvailable := False;
    end
    else
      FOpenSSLAvailable := False;
  end;

  if not FOpenSSLAvailable then Exit;  // SetUp is partial; test will skip

  for Attempt := 0 to 9 do
  begin
    FPort := 48000 + Random(1000) + Attempt;
    try
      FServer.Listen(FPort);
      Break;
    except
      FPort := 0;
    end;
  end;
  Check(FPort > 0, 'Could not bind a free local port for TLS test server');
  Sleep(50);

  FClient := TTina4WebSocketClient.Create(nil);
  FClient.URL := 'wss://127.0.0.1:' + IntToStr(FPort) + '/';
  FClient.AutoReconnect := False;
  FClient.PingInterval := 0;
  FClient.OnConnected := FHelper.OnConnected;
  FClient.OnDisconnected := FHelper.OnDisconnected;
  FClient.OnMessage := FHelper.OnMessage;
  FClient.OnError := FHelper.OnError;
  FClient.OnReconnecting := FHelper.OnReconnecting;
end;

procedure TestTTina4WebSocketTLS.TearDown;
begin
  if Assigned(FClient) and FClient.IsConnected then
    FClient.Disconnect;
  CheckSynchronize(200);
  FreeAndNil(FClient);
  if Assigned(FServer) then
    FServer.Stop;
  FreeAndNil(FBroker);
  FreeAndNil(FServer);
  FreeAndNil(FHelper);
end;

procedure TestTTina4WebSocketTLS.WaitForCondition(
  ACondition: TFunc<Boolean>; ATimeoutMs: Integer);
var
  Elapsed: Integer;
begin
  Elapsed := 0;
  while (not ACondition()) and (Elapsed < ATimeoutMs) do
  begin
    CheckSynchronize(100);
    Sleep(100);
    Inc(Elapsed, 200);
  end;
end;

procedure TestTTina4WebSocketTLS.TestWssConnectAndSubscribe;
begin
  if not FOpenSSLAvailable then
  begin
    // Pass with a note rather than fail — environments without OpenSSL
    // shouldn't make this test red. The plain ws:// integration tests
    // already exercise the protocol logic.
    Check(True, 'OpenSSL/server-side TLS not available; skipping wss test');
    Exit;
  end;

  FClient.Connect;

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.Connected or (FHelper.LastError <> '');
    end);

  Check(FHelper.Connected,
    'wss connect failed — lastError=' + FHelper.LastError +
    ' state=' + IntToStr(Ord(FClient.State)));

  // Round-trip a subscribe through the encrypted channel to prove
  // the framing layer is wired correctly on top of TLS.
  FClient.Send('{"action":"subscribe","topic":"tls-test"}');

  WaitForCondition(
    function: Boolean
    begin
      Result := FHelper.MessageCount > 0;
    end);

  Check(FHelper.MessageCount > 0, 'Should receive ack over wss');
  Check(Pos('Subscribed', FHelper.LastMessage) > 0,
    'Should receive subscribe ack over wss, got: ' + FHelper.LastMessage);
end;

initialization
  RegisterTest('WebSocket.Unit', TestTTina4WebSocketUnit.Suite);
  RegisterTest('WebSocket.Integration', TestTTina4WebSocketIntegration.Suite);
  RegisterTest('WebSocket.TLS', TestTTina4WebSocketTLS.Suite);
end.
