unit DataModule;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, FMX.Dialogs, IdContext, IdScheduler, IdSchedulerOfThread, IdSchedulerOfThreadPool, IdServerIOHandler, IdSSL, IdSSLOpenSSL, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, Tina4Core, JSON, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Tina4REST, Tina4Route,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, Tina4RESTRequest, FireDAC.Stan.StorageBin, Tina4WebServer, REST.Types, REST.Response.Adapter, System.Net.URLClient,
  Tina4JSONAdapter;

type
  TfrmDataModule = class(TDataModule)
    IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDMemTable1: TFDMemTable;
    IdHTTPServer1: TIdHTTPServer;
    FDMemTable2: TFDMemTable;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    Tina4WebServer1: TTina4WebServer;
    Tina4RESTRequest1: TTina4RESTRequest;
    Tina4JSONAdapter1: TTina4JSONAdapter;
    FDMemTable3: TFDMemTable;

    procedure Tina4HttpServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Tina4RESTRequest1ExecuteDone(Sender: TObject);
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
var
  JSONValue : TJSONPair;
  StatusCode : Integer;

begin
  var CustomHeaders : TUrlHeaders;
  CustomHeaders := TUrlHeaders.Create;

  try
  CustomHeaders.Add('Authorization','Bearer abc');
  var Entries := SendHttpRequest (StatusCode, 'http://localhost:7112/api', 'admin/users', '', '', 'application/json', 'utf-8', '', '', CustomHeaders);
  //BaseURL: String; EndPoint: String = ''; QueryParams: String = ''; Body: String=''; ContentType: String = 'application/json';  ContentEncoding : String = 'utf-8'; Username:String = ''; Password: String = ''; CustomHeaders: TStringList = nil;
  //WriteLn(Entries);

  //WriteLn(StrToJSONArray('["hello", "fellow"]').toString);
  Tina4RESTRequest1.ExecuteRESTCallAsync;

  finally
    CustomHeaders.Free;
  end;

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

procedure TfrmDataModule.Tina4RESTRequest1ExecuteDone(Sender: TObject);
begin
  WriteLn('Fetched Data!');
  Writeln((Sender as TTina4RESTRequest).ResponseBody.Text);
 // ShowMessage('Hello');
end;

end.
