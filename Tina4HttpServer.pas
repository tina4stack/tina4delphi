unit Tina4HttpServer;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer,
  JSON, FireDAC.DApt, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, Tina4Core;

type
  TTina4HttpServer = class(TIdHTTPServer)
  private
    { Private declarations }
    FConnection: TFDConnection;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); overload;
    function JSONFromDB(SQL: String; DataSetName : String = 'records'; Params: TFDParams = nil) : TJSONObject;
  published
    { Published declarations }
    property Connection : TFDConnection read FConnection write FConnection;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4HttpServer]);
end;

{ TTina4HttpServer }

constructor TTina4HttpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //Look for Tina4Route components belonging to the same project or parent to create a path map



end;

function TTina4HttpServer.JSONFromDB(SQL, DataSetName: String; Params: TFDParams): TJSONObject;
begin
  if Assigned(FConnection) then
  begin
    Result := GetJSONFromDB(Self.FConnection, SQL, Params, DataSetName);
  end
    else
  begin
    Result := TJSONObject.Create;
    Result.AddPair('error', 'Please assign a FDConnection database component to the Tina4HttpServer component')
  end;
end;

end.
