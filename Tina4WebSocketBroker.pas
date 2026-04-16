unit Tina4WebSocketBroker;

(*
  Tina4WebSocketBroker

  Pub-sub layer sitting on top of Tina4WebSocketServer. Handles a JSON
  action protocol compatible with tina4-python's frond WebSocket:

    Client subscribe:   {"action":"subscribe","topic":"chat"}
    Server ack:         {"action":"ack","topic":"chat","message":"Subscribed to chat"}

    Client publish:     {"action":"publish","topic":"chat","message":{...}}
    Server ack:         {"action":"ack","topic":"chat","message":"Published to chat"}
    Subscribers of chat receive:
                        {"action":"message","topic":"chat","message":{...}}

    Client unsubscribe: {"action":"unsubscribe","topic":"chat"}
    Server ack:         {"action":"ack","topic":"chat","message":"Unsubscribed from chat"}

  The broker keeps a topic to list-of-connection map guarded by a lock.
  Each connection's UserData slot carries its own subscription set so
  disconnects clean up in O(topics-subscribed-to) rather than O(total).
*)

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.JSON,
  System.Generics.Collections,
  Tina4WebSocketServer;

type
  /// <summary>
  /// Per-connection state carried in TTina4WSConnection.UserData.
  /// Tracks which topics this connection is subscribed to.
  /// </summary>
  TTina4WSClientState = class
  private
    FTopics: TList<string>;
    FLock: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTopic(const ATopic: string);
    procedure RemoveTopic(const ATopic: string);
    function HasTopic(const ATopic: string): Boolean;
    function Snapshot: TArray<string>;
  end;

  /// <summary>
  /// Pub-sub broker. Attach to a TTina4WebSocketServer via Attach();
  /// the broker wires up OnConnect/OnMessage/OnDisconnect and handles
  /// the action protocol. You can still read the server's events by
  /// setting additional handlers after Attach.
  /// </summary>
  TTina4WebSocketBroker = class
  private
    FServer: TTina4WebSocketServer;
    FTopics: TDictionary<string, TList<TTina4WSConnection>>;
    FTopicsLock: TCriticalSection;
    procedure HandleConnect(Sender: TObject; Connection: TTina4WSConnection);
    procedure HandleDisconnect(Sender: TObject; Connection: TTina4WSConnection;
      ACode: Integer; const AReason: string);
    procedure HandleMessage(Sender: TObject; Connection: TTina4WSConnection;
      const AMessage: string);
    procedure DoSubscribe(AConn: TTina4WSConnection; const ATopic: string);
    procedure DoUnsubscribe(AConn: TTina4WSConnection; const ATopic: string);
    procedure DoPublish(AConn: TTina4WSConnection; const ATopic: string;
      AMessage: TJSONValue);
    procedure SendAck(AConn: TTina4WSConnection;
      const ATopic, AMessage: string);
    procedure RemoveFromAllTopics(AConn: TTina4WSConnection);
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// Binds this broker to a server's lifecycle events. Only one
    /// broker per server — Attach overwrites any previous handlers.
    /// </summary>
    procedure Attach(AServer: TTina4WebSocketServer);
    /// <summary>Number of subscribers to a given topic.</summary>
    function SubscriberCount(const ATopic: string): Integer;
    /// <summary>
    /// Fan-out to every subscriber of ATopic. Useful for pushing
    /// server-originated events that didn't come through a publish
    /// from a client.
    /// </summary>
    procedure Broadcast(const ATopic: string; AMessage: TJSONValue);
  end;

implementation

{ ---- TTina4WSClientState ---- }

constructor TTina4WSClientState.Create;
begin
  inherited;
  FTopics := TList<string>.Create;
  FLock := TCriticalSection.Create;
end;

destructor TTina4WSClientState.Destroy;
begin
  FreeAndNil(FTopics);
  FreeAndNil(FLock);
  inherited;
end;

procedure TTina4WSClientState.AddTopic(const ATopic: string);
begin
  FLock.Enter;
  try
    if FTopics.IndexOf(ATopic) < 0 then
      FTopics.Add(ATopic);
  finally
    FLock.Leave;
  end;
end;

procedure TTina4WSClientState.RemoveTopic(const ATopic: string);
begin
  FLock.Enter;
  try
    FTopics.Remove(ATopic);
  finally
    FLock.Leave;
  end;
end;

function TTina4WSClientState.HasTopic(const ATopic: string): Boolean;
begin
  FLock.Enter;
  try
    Result := FTopics.IndexOf(ATopic) >= 0;
  finally
    FLock.Leave;
  end;
end;

function TTina4WSClientState.Snapshot: TArray<string>;
begin
  FLock.Enter;
  try
    Result := FTopics.ToArray;
  finally
    FLock.Leave;
  end;
end;

{ ---- TTina4WebSocketBroker ---- }

constructor TTina4WebSocketBroker.Create;
begin
  inherited;
  FTopics := TDictionary<string, TList<TTina4WSConnection>>.Create;
  FTopicsLock := TCriticalSection.Create;
end;

destructor TTina4WebSocketBroker.Destroy;
var
  ConnList: TList<TTina4WSConnection>;
begin
  FTopicsLock.Enter;
  try
    for ConnList in FTopics.Values do
      ConnList.Free;
    FTopics.Clear;
  finally
    FTopicsLock.Leave;
  end;
  FreeAndNil(FTopics);
  FreeAndNil(FTopicsLock);
  inherited;
end;

procedure TTina4WebSocketBroker.Attach(AServer: TTina4WebSocketServer);
begin
  FServer := AServer;
  FServer.OnConnect := HandleConnect;
  FServer.OnDisconnect := HandleDisconnect;
  FServer.OnMessage := HandleMessage;
end;

procedure TTina4WebSocketBroker.HandleConnect(Sender: TObject;
  Connection: TTina4WSConnection);
begin
  // Give each connection a fresh state object. The connection owns
  // it from here — we free it in HandleDisconnect. Using UserData
  // avoids a parallel map keyed by connection pointer.
  Connection.UserData := TTina4WSClientState.Create;
end;

procedure TTina4WebSocketBroker.HandleDisconnect(Sender: TObject;
  Connection: TTina4WSConnection; ACode: Integer; const AReason: string);
var
  State: TTina4WSClientState;
begin
  RemoveFromAllTopics(Connection);
  if Connection.UserData is TTina4WSClientState then
  begin
    State := TTina4WSClientState(Connection.UserData);
    Connection.UserData := nil;
    State.Free;
  end;
end;

procedure TTina4WebSocketBroker.HandleMessage(Sender: TObject;
  Connection: TTina4WSConnection; const AMessage: string);
var
  JSON: TJSONValue;
  Obj: TJSONObject;
  Action, Topic: string;
  MsgField: TJSONValue;
begin
  // Parse the incoming message. If it isn't a JSON object with an
  // "action" field, silently ignore — we stay strict about our own
  // wire format and don't guess.
  JSON := nil;
  try
    try
      JSON := TJSONObject.ParseJSONValue(AMessage);
    except
      Exit;
    end;
    if not (JSON is TJSONObject) then Exit;
    Obj := TJSONObject(JSON);

    Action := '';
    Topic := '';
    if Obj.GetValue('action') <> nil then
      Action := Obj.GetValue('action').Value;
    if Obj.GetValue('topic') <> nil then
      Topic := Obj.GetValue('topic').Value;

    if Topic = '' then Exit;

    if Action = 'subscribe' then
      DoSubscribe(Connection, Topic)
    else if Action = 'unsubscribe' then
      DoUnsubscribe(Connection, Topic)
    else if Action = 'publish' then
    begin
      MsgField := Obj.GetValue('message');
      DoPublish(Connection, Topic, MsgField);
    end;
  finally
    if JSON <> nil then JSON.Free;
  end;
end;

procedure TTina4WebSocketBroker.DoSubscribe(AConn: TTina4WSConnection;
  const ATopic: string);
var
  ConnList: TList<TTina4WSConnection>;
  State: TTina4WSClientState;
begin
  FTopicsLock.Enter;
  try
    if not FTopics.TryGetValue(ATopic, ConnList) then
    begin
      ConnList := TList<TTina4WSConnection>.Create;
      FTopics.Add(ATopic, ConnList);
    end;
    if ConnList.IndexOf(AConn) < 0 then
      ConnList.Add(AConn);
  finally
    FTopicsLock.Leave;
  end;

  if AConn.UserData is TTina4WSClientState then
  begin
    State := TTina4WSClientState(AConn.UserData);
    State.AddTopic(ATopic);
  end;

  SendAck(AConn, ATopic, 'Subscribed to ' + ATopic);
end;

procedure TTina4WebSocketBroker.DoUnsubscribe(AConn: TTina4WSConnection;
  const ATopic: string);
var
  ConnList: TList<TTina4WSConnection>;
  State: TTina4WSClientState;
begin
  FTopicsLock.Enter;
  try
    if FTopics.TryGetValue(ATopic, ConnList) then
      ConnList.Remove(AConn);
  finally
    FTopicsLock.Leave;
  end;

  if AConn.UserData is TTina4WSClientState then
  begin
    State := TTina4WSClientState(AConn.UserData);
    State.RemoveTopic(ATopic);
  end;

  SendAck(AConn, ATopic, 'Unsubscribed from ' + ATopic);
end;

procedure TTina4WebSocketBroker.DoPublish(AConn: TTina4WSConnection;
  const ATopic: string; AMessage: TJSONValue);
var
  ConnList: TList<TTina4WSConnection>;
  Subscribers: TArray<TTina4WSConnection>;
  C: TTina4WSConnection;
  Payload: TJSONObject;
  MsgClone: TJSONValue;
  PayloadStr: string;
begin
  // Snapshot the subscriber list under the lock so we can release
  // it before doing I/O — a slow send would otherwise block
  // everyone else's subscribe/unsubscribe.
  SetLength(Subscribers, 0);
  FTopicsLock.Enter;
  try
    if FTopics.TryGetValue(ATopic, ConnList) then
      Subscribers := ConnList.ToArray;
  finally
    FTopicsLock.Leave;
  end;

  // Build the fan-out payload once, reuse the string for every
  // subscriber (we can't share TJSONObject ownership across sends).
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('action', 'message');
    Payload.AddPair('topic', ATopic);
    if AMessage <> nil then
    begin
      // Clone so the caller's parsed TJSONValue isn't double-freed.
      MsgClone := TJSONObject.ParseJSONValue(AMessage.ToString);
      if MsgClone <> nil then
        Payload.AddPair('message', MsgClone);
    end;
    PayloadStr := Payload.ToString;
  finally
    Payload.Free;
  end;

  // Skip the publisher — the convention (matching tina4-python) is
  // that the publisher gets a single ack, while every OTHER subscriber
  // receives the broadcast.
  for C in Subscribers do
  begin
    if (C <> nil) and (C <> AConn) and C.IsOpen then
      try C.Send(PayloadStr); except end;
  end;

  SendAck(AConn, ATopic, 'Published to ' + ATopic);
end;

procedure TTina4WebSocketBroker.SendAck(AConn: TTina4WSConnection;
  const ATopic, AMessage: string);
var
  Ack: TJSONObject;
begin
  Ack := TJSONObject.Create;
  try
    Ack.AddPair('action', 'ack');
    Ack.AddPair('topic', ATopic);
    Ack.AddPair('message', AMessage);
    try AConn.Send(Ack.ToString); except end;
  finally
    Ack.Free;
  end;
end;

procedure TTina4WebSocketBroker.RemoveFromAllTopics(AConn: TTina4WSConnection);
var
  State: TTina4WSClientState;
  Topic: string;
  ConnList: TList<TTina4WSConnection>;
begin
  if not (AConn.UserData is TTina4WSClientState) then Exit;
  State := TTina4WSClientState(AConn.UserData);
  // Walk only the topics this connection was actually subscribed to.
  for Topic in State.Snapshot do
  begin
    FTopicsLock.Enter;
    try
      if FTopics.TryGetValue(Topic, ConnList) then
        ConnList.Remove(AConn);
    finally
      FTopicsLock.Leave;
    end;
  end;
end;

function TTina4WebSocketBroker.SubscriberCount(const ATopic: string): Integer;
var
  ConnList: TList<TTina4WSConnection>;
begin
  Result := 0;
  FTopicsLock.Enter;
  try
    if FTopics.TryGetValue(ATopic, ConnList) then
      Result := ConnList.Count;
  finally
    FTopicsLock.Leave;
  end;
end;

procedure TTina4WebSocketBroker.Broadcast(const ATopic: string;
  AMessage: TJSONValue);
var
  ConnList: TList<TTina4WSConnection>;
  Subscribers: TArray<TTina4WSConnection>;
  C: TTina4WSConnection;
  Payload: TJSONObject;
  MsgClone: TJSONValue;
  PayloadStr: string;
begin
  SetLength(Subscribers, 0);
  FTopicsLock.Enter;
  try
    if FTopics.TryGetValue(ATopic, ConnList) then
      Subscribers := ConnList.ToArray;
  finally
    FTopicsLock.Leave;
  end;

  Payload := TJSONObject.Create;
  try
    Payload.AddPair('action', 'message');
    Payload.AddPair('topic', ATopic);
    if AMessage <> nil then
    begin
      MsgClone := TJSONObject.ParseJSONValue(AMessage.ToString);
      if MsgClone <> nil then
        Payload.AddPair('message', MsgClone);
    end;
    PayloadStr := Payload.ToString;
  finally
    Payload.Free;
  end;

  for C in Subscribers do
  begin
    if (C <> nil) and C.IsOpen then
      try C.Send(PayloadStr); except end;
  end;
end;

end.
