unit Tina4RESTRequest;

interface

uses
  System.SysUtils, System.Variants, System.Generics.Collections, System.Classes, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Tina4Core, Tina4REST, JSON, System.RegularExpressions
  {$IFDEF MSWINDOWS}
  ,FMX.Dialogs
  {$ENDIF}
  ;

type
  TTina4RESTRequest = class(TComponent)
  private
    { Private declarations }
    FMemTable: TFDMemTable;
    FSourceMemTable: TFDMemTable;
    FTina4REST: TTina4REST;
    FEndPoint: String;
    FQueryParams: String;
    FDataKey : String;
    FResponseBody: TStringList;
    FRequestBody: TStringList;
    FOnExecuteDone: TTina4Event;
    FOnAddRecord: TTina4AddRecordEvent;
    FRequestType: TTina4RequestType;
    FMasterSource: TTina4RESTRequest;
    FSourceIgnoreFields: String;
    FSourceIgnoreBlanks: Boolean;
    FSyncMode: TTina4RestSyncMode;
    FIndexFieldNames: String;
    procedure SetMasterSource(const Source: TTina4RESTRequest);
    procedure SetResponseBody(List: TStringList);
    procedure SetRequestBody(List: TStringList);
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure ExecuteRESTCall;
    procedure ExecuteRESTCallAsync;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property SyncMode: TTina4RestSyncMode read FSyncMode write FSyncMode;
    property IndexFieldNames: String read FIndexFieldNames write FIndexFieldNames;
    property RequestType: TTina4RequestType read FRequestType write FRequestType;
    property DataKey: String read FDataKey write FDataKey;
    property EndPoint: String read FEndPoint write FEndPoint;
    property QueryParams: String read FQueryParams write FQueryParams;
    property MemTable: TFDMemTable read FMemTable write FMemTable;
    property SourceMemTable: TFDMemTable read FSourceMemTable write FSourceMemTable;
    property SourceIgnoreFields: String read FSourceIgnoreFields write FSourceIgnoreFields;
    property SourceIgnoreBlanks: Boolean read FSourceIgnoreBlanks write FSourceIgnoreBlanks;
    property Tina4REST: TTina4REST read FTina4REST write FTina4REST;
    property MasterSource: TTina4RESTRequest read FMasterSource write SetMasterSource;
    property ResponseBody: TStringList read FResponseBody write SetResponseBody;
    property RequestBody: TStringList read FRequestBody write SetRequestBody;
    property OnAddRecord :  TTina4AddRecordEvent read FOnAddRecord write FOnAddRecord;
    property OnExecuteDone: TTina4Event read FOnExecuteDone write FOnExecuteDone;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4RESTRequest]);
end;

{ TTina4RESTRequest }

constructor TTina4RESTRequest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResponseBody := TStringList.Create;
  FRequestBody := TStringList.Create;
end;

destructor TTina4RESTRequest.Destroy;
begin
  FResponseBody.Free;
  FRequestBody.Free;
  inherited;
end;

procedure TTina4RESTRequest.ExecuteRESTCall;
var
  Response: TJSONObject;


procedure InjectMasterSourceParams(const MasterSource: TTina4RestRequest; var EndPoint:String; var RequestBody: String; var QueryParams: String);
var RegEx: TRegEx;
begin
  if MasterSource = nil then Exit;
  if MasterSource.MemTable = nil then Exit;

  //run a regex on the EndPoint, RequestBody, QueryParams looking for {fieldName} to inject
  for var I := 0 to MasterSource.MemTable.FieldDefs.Count-1 do
  begin
    RegEx.Create('\{'+MasterSource.MemTable.FieldDefs[I].Name+'\}');

    EndPoint := RegEx.Replace(Endpoint, MasterSource.MemTable.FieldByName(MasterSource.MemTable.FieldDefs[I].Name).AsString);
    RequestBody := RegEx.Replace(RequestBody, MasterSource.MemTable.FieldByName(MasterSource.MemTable.FieldDefs[I].Name).AsString);
    QueryParams := RegEx.Replace(QueryParams, MasterSource.MemTable.FieldByName(MasterSource.MemTable.FieldDefs[I].Name).AsString);
  end;
end;



begin
  if Assigned(Self.FTina4REST) then
  begin
    FResponseBody.Clear;
    Response := nil;

    var EndPoint : String := Self.EndPoint;
    var RequestBody : String := Self.FRequestBody.Text;
    var QueryParams : String := Self.QueryParams;


    InjectMasterSourceParams(FMasterSource, EndPoint, RequestBody, QueryParams);

    if Assigned(FSourceMemTable) then
    begin
      var JSONObject : TJSONObject := GetJSONFromTable(FSourceMemTable, 'records', FSourceIgnoreFields, FSourceIgnoreBlanks);
      try
        if JSONObject.GetValue<TJSONArray>('records').Count = 1 then
        begin
          FRequestBody.Text := JSONObject.GetValue<TJSONArray>('records').Items[0].ToJSON;
        end
          else
        begin
          FRequestBody.Text := JSONObject.GetValue<TJSONArray>('records').ToJSON;
        end;
        RequestBody := FRequestBody.Text;
      finally
        JSONObject.Free;
      end;
    end;

    if (FRequestType = TTina4RequestType.Get) then
    begin
      Response := FTina4REST.Get(EndPoint, QueryParams);
    end
      else
    if (FRequestType = TTina4RequestType.Delete) then
    begin
      Response := FTina4REST.Delete(EndPoint, QueryParams);
    end
      else
    if (FRequestType = TTina4RequestType.Post) then
    begin
      Response := FTina4REST.Post(EndPoint, QueryParams, RequestBody);
    end
      else
    if (FRequestType = TTina4RequestType.Patch) then
    begin
      Response := FTina4REST.Patch(EndPoint, QueryParams, RequestBody);
    end
      else
    if (FRequestType = TTina4RequestType.Put) then
    begin
      Response := FTina4REST.Put(EndPoint, QueryParams, RequestBody);
    end;

    try
      if (Response = nil) then
      begin
        FResponseBody.Text := '{"error": "Could not get a reply from the server!"}';
        if (Assigned(Self.FOnExecuteDone)) then
        begin
          Self.FOnExecuteDone(Self);
        end;
        Exit;
      end;

      FResponseBody.Text := Response.ToString;
      PopulateMemTableFromJSON(FMemTable, DataKey, Self.FResponseBody.Text, Self.FIndexFieldNames, SyncMode, Self);
      if (Assigned(Self.FOnExecuteDone)) then
      begin
        Self.FOnExecuteDone(Self);
      end;

    finally
      Response.Free;
    end;
  end
    else
  begin
    {$IFDEF MSWINDOWS}
    ShowMessage('Assign a Tina4REST component to '+Self.Name);
    {$ENDIF}
  end;
end;


procedure TTina4RESTRequest.ExecuteRESTCallAsync;
begin
  var Thread := TThread.CreateAnonymousThread(
  procedure
  begin
    Self.ExecuteRESTCall;
  end
  );
  Thread.FreeOnTerminate := True;
  Thread.Start;
end;

procedure TTina4RESTRequest.SetMasterSource(const Source: TTina4RESTRequest);
begin
  if Source <>  nil then
  begin
    if Source.Name <> Self.Name then
    begin
      FMasterSource := Source;
    end
      else
    begin
      FMasterSource := nil;
    end;
  end;
end;

procedure TTina4RESTRequest.SetRequestBody(List: TStringList);
begin
  FRequestBody.Assign(List);
end;

procedure TTina4RESTRequest.SetResponseBody(List: TStringList);
begin
  FResponseBody.Assign(List);
end;

end.
