unit DataModule;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, Tina4HttpServer, IdContext, IdScheduler, IdSchedulerOfThread, IdSchedulerOfThreadPool, IdServerIOHandler, IdSSL, IdSSLOpenSSL, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, Tina4Core, JSON, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Tina4REST, Tina4Route,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, Tina4RESTRequest;

type
  TfrmDataModule = class(TDataModule)
    Tina4HttpServer1: TTina4HttpServer;
    IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    Tina4Route1: TTina4Route;
    Tina4REST1: TTina4REST;
    RESTRequest1: TRESTRequest;
    Tina4RESTRequest1: TTina4RESTRequest;
    procedure Tina4HttpServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetBrands() : TJSONObject;
    function GetSBrands(): TJSONObject;
    function GetEntries(): TJSONObject;
  end;

var
  frmDataModule: TfrmDataModule;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TfrmDataModule.GetBrands: TJSONObject;
begin
  Result := GetJSONFromDB(FDConnection1, 'select * from brands');
  WriteLn(Result.ToString);
end;

function TfrmDataModule.GetEntries: TJSONObject;
begin
  //var Entries := SendHttpRequest ('https://api.publicapis.org', 'entries');

  var entries := Tina4Rest1.Get('entries');
  WriteLn(entries.ToString);

end;

function TfrmDataModule.GetSBrands: TJSONObject;
var
  Params: TFDParams;
begin
  Params := TFDParams.Create;
  try
    Params.Add('name', '%', TParamType.ptInput);

    Result := GetJSONFromDB(FDConnection1, 'select * from brands where brand_name like :name',  Params, 'brands');
    WriteLn(Result.ToString);
  finally
    Params.Free;
  end;
end;

procedure TfrmDataModule.Tina4HttpServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  i: Integer;
begin
  AResponseInfo.ResponseText := 'Hello';
  WriteLn('Received ....');
  WriteLn('Request:'+ARequestInfo.Document);

  i := 0;
  while i < 10000 do
  begin
    WriteLn('Running '+IntToStr(i));
    i := i + 1;
  end;
end;

end.
