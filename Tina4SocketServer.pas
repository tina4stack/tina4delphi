unit Tina4SocketServer;

interface

uses System.SysUtils, System.Classes, System.Net.Socket, System.Types, JSON;

type
  TTina4SocketServer = class(TComponent)

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4SocketServer]);
end;

end.


(*procedure HandleSocketConnection(const Socket: TSocket);
var
  Disconnected : Boolean;

begin
  WriteLn('Receiving the Socket Connection');

  Disconnected := False;

  while not Disconnected do
  begin
    WriteLn('Waiting for a connection');
    var Content: TBytes := Socket.Receive();
    if StringOf(Content) <> '' then
    begin
      WriteLn (StringOf(Content));
      if Pos( 'quit', StringOf(Content)) <> 0 then
      begin
        Disconnected := True;
        Socket.Close;
      end;
    end;
    Sleep(1000);
  end;
end;

procedure HandleConnection(const ASyncResult: IAsyncResult);
begin
  WriteLn('New Connection');
  var Socket := (ASyncResult.AsyncContext  as TSocket);

  var Connection := Socket.EndAccept(ASyncResult);

  HandleSocketConnection(Connection);
end;

var
  ServerSocket: TSocket;

begin
  ReportMemoryLeaksOnShutDown := True;
  ServerSocket := TSocket.Create(TSocketType.TCP);

  ServerSocket.Listen('127.0.0.1', '', 9006);
  try
    while True do
    begin
      var Handler := ServerSocket.BeginAccept(HandleConnection);
      WriteLn('Listening');
      Sleep(1000);
    end;

  finally
    ServerSocket.Free;
  end;
end.   *)
