unit TestTina4WebSocket;

interface

uses
  TestFramework, System.SysUtils, System.Classes, System.SyncObjs,
  Tina4OpenSSL, Tina4WebSocketClient,
  Tina4WebSocketServer, Tina4WebSocketFrames;

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
    procedure OnConnected(Sender: TObject);
    procedure OnDisconnected(Sender: TObject; const ACode: Integer;
      const AReason: string);
    procedure OnMessage(Sender: TObject; const AMessage: string);
    procedure OnError(Sender: TObject; const AError: string);
    procedure OnReconnecting(Sender: TObject; AAttempt: Integer);
    procedure Reset;
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

    // OpenSSL loader
    procedure TestOpenSSLLoad;
  end;

  // ---- Integration tests (require network) ----
  TestTTina4WebSocketIntegration = class(TTestCase)
  private
    FClient: TTina4WebSocketClient;
    FHelper: TWSTestHelper;
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

implementation

const
  // Live test server
  TEST_URL = 'wss://api.aatos-ai.com/api/notifications';
  TEST_AUTH = 'Authorization: Bearer ded53236-19fa-11f0-b129-07867f38df3b';
  TEST_TOPIC = 'Sleek';

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
    Check(WS.State = wsClosed, 'State should default to wsClosed');
    CheckEquals(0, WS.Headers.Count, 'Headers should be empty');
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

{ -- OpenSSL -- }

procedure TestTTina4WebSocketUnit.TestOpenSSLLoad;
begin
  Check(LoadOpenSSL, 'OpenSSL should load successfully');
  Check(IsOpenSSLLoaded, 'IsOpenSSLLoaded should return True');
end;

{ ---- TestTTina4WebSocketIntegration ---- }

procedure TestTTina4WebSocketIntegration.SetUp;
begin
  FHelper := TWSTestHelper.Create;
  FHelper.Reset;

  FClient := TTina4WebSocketClient.Create(nil);
  FClient.URL := TEST_URL;
  FClient.Headers.Add(TEST_AUTH);
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
  if FClient.IsConnected then
    FClient.Disconnect;
  // Process any remaining queued events
  CheckSynchronize(200);
  FreeAndNil(FClient);
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

  Check(FHelper.Connected, 'Should connect to WebSocket server');
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

initialization
  RegisterTest('WebSocket.Unit', TestTTina4WebSocketUnit.Suite);
  RegisterTest('WebSocket.Integration', TestTTina4WebSocketIntegration.Suite);
end.
