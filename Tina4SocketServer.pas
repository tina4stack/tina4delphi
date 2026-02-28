unit Tina4SocketServer;

interface

uses System.SysUtils, System.Classes, System.Net.Socket, System.Types, JSON, System.Threading;

type
  TTina4SocketEvent = procedure (const Client: TSocket; Content: TBytes) of Object;

  TTina4SocketServer = class(TComponent)
  private
    FSocketType: TSocketType;
    FHost: String;
    FPort: Integer;
    FActive: Boolean;
    FOnMessage: TTina4SocketEvent;
    CanRun: Boolean;
    ServerSocket : TSocket;
    ServiceTask: ITask;
  protected
    { Protected declarations }
    procedure HandleConnection(const ASyncResult: IAsyncResult);
    procedure ProcessSocketConnection(const Client: TSocket);
  public
    procedure SetActive(const Active: Boolean);
    procedure StartService(Host: String; Port: Integer; SocketType: TSocketType; HandleConnection: TAsyncCallbackEvent);
    procedure StopService();
  published
    property Active: Boolean read FActive write SetActive;
    property Port : Integer read FPort write FPort;
    property Host : String read FHost write FHost;
    property SocketType : TSocketType read FSocketType write FSocketType;
    property OnMessage : TTina4SocketEvent read FOnMessage write FOnMessage;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4SocketServer]);
end;

{ TTina4SocketServer }

procedure TTina4SocketServer.ProcessSocketConnection(const Client: TSocket);
var
  IsDisconnected: Boolean;
begin
  IsDisconnected := False;
  while not IsDisconnected and CanRun do
  begin
    try
      var ReceivedBytes: TBytes := Client.Receive();
      if Assigned(FOnMessage) and (Length(ReceivedBytes) > 0) then
        FOnMessage(Client, ReceivedBytes);
      Sleep(1000);
    except
      IsDisconnected := True;
    end;
  end;
  Client.Close(True);
end;

procedure TTina4SocketServer.SetActive(const Active: Boolean);
begin
  if not FActive and Active then
    StartService(FHost, FPort, FSocketType, HandleConnection)
  else
    StopService();
  FActive := Active;
end;

procedure TTina4SocketServer.StartService(Host: String; Port: Integer; SocketType: TSocketType; HandleConnection: TAsyncCallbackEvent);
begin
  if Assigned(ServiceTask) then
    Exit;

  ServiceTask := TTask.Create(
    procedure
    begin
      ServerSocket := TSocket.Create(SocketType);
      ServerSocket.Listen(Host, '', Port);
      CanRun := True;
      try
        while CanRun do
        begin
          ServerSocket.BeginAccept(HandleConnection);
          Sleep(1000);
        end;
      finally
        ServerSocket.Free;
      end;
    end);
  ServiceTask.Start;
end;

procedure TTina4SocketServer.HandleConnection(const ASyncResult: IAsyncResult);
begin
  var ListenSocket := ASyncResult.AsyncContext as TSocket;
  var ClientSocket := ListenSocket.EndAccept(ASyncResult);
  ProcessSocketConnection(ClientSocket);
end;

procedure TTina4SocketServer.StopService;
begin
  CanRun := False;
  if Assigned(ServiceTask) then
    ServiceTask.Cancel;
end;

end.

