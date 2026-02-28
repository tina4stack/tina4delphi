unit Tina4WebServer;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer,
  JSON, FireDAC.DApt, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, Tina4Core, IdContext;

type
  TTina4WebServer = class(TComponent)
  private
    { Private declarations }
    FConnection: TFDConnection;
    FHTTPServer: TIdHTTPServer;
    FPublicPath: String;
    FActive: Boolean;
    procedure HandleWebEvents(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function JSONFromDB(SQL: String; DataSetName : String = 'records'; Params: TFDParams = nil) : TJSONObject;
    procedure SetActive(Active: Boolean);
  published
    { Published declarations }
    property Connection : TFDConnection read FConnection write FConnection;
    property HTTPServer: TIdHTTPServer read FHTTPServer write FHTTPServer;
    property PublicPath: String read FPublicPath write FPublicPath;
    property Active : Boolean read FActive write SetActive;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4WebServer]);
end;

{ TTina4WebServer }

constructor TTina4WebServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TTina4WebServer.HandleWebEvents(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  //Handle what happends with webserver requests
  WriteLn('Something happened!'+ARequestInfo.RawHeaders.Text);
  WriteLn(ARequestInfo.URI);
  WriteLn(ARequestInfo.Command);

  //Check for Files in the public folder

  //Check Routes
  //for var I := 0 t do
  //  begin
  //    WriteLn(Self.Components[I].ClassName+ ' '+Self.Components[I].Name);
  //  end;


  //Check Templates
end;

function TTina4WebServer.JSONFromDB(SQL, DataSetName: String; Params: TFDParams): TJSONObject;
begin
  if Assigned(FConnection) then
    Result := GetJSONFromDB(FConnection, SQL, Params, DataSetName)
  else
  begin
    Result := TJSONObject.Create;
    Result.AddPair('error', 'Please assign a FDConnection database component to the Tina4HttpServer component')
  end;
end;

procedure TTina4WebServer.SetActive(Active: Boolean);
begin
  if Assigned(FHTTPServer) then
  begin
    FHTTPServer.Active := Active;
    FHTTPServer.OnCommandGet := HandleWebEvents;
    FHTTPServer.OnCommandOther := HandleWebEvents;
  end;
  FActive := Active;
end;

end.
