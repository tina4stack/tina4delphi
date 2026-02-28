unit Tina4RESTRequest;

interface

uses
  System.SysUtils, System.Classes, System.RegularExpressions, JSON, Tina4Core, System.Net.URLClient, System.StrUtils,FireDAC.Comp.Client, Tina4REST
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
    FStatusCode: Integer;
    FTransformResultToSnakeCase: Boolean;
    FFreeOnAsyncExecute: Boolean;
    procedure SetMasterSource(const Source: TTina4RESTRequest);
    procedure SetMemTable(const Value: TFDMemTable);
    procedure SetSourceMemTable(const Value: TFDMemTable);
    procedure SetTina4REST(const Value: TTina4REST);
    procedure SetResponseBody(List: TStringList);
    procedure SetRequestBody(List: TStringList);

  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    procedure ExecuteRESTCall;
    procedure ExecuteRESTCallAsync;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property TransformResultToSnakeCase: Boolean read FTransformResultToSnakeCase write FTransformResultToSnakeCase;
    property FreeOnAsyncExecute: Boolean read FFreeOnAsyncExecute write FFreeOnAsyncExecute;
    property SyncMode: TTina4RestSyncMode read FSyncMode write FSyncMode;
    property IndexFieldNames: String read FIndexFieldNames write FIndexFieldNames;
    property RequestType: TTina4RequestType read FRequestType write FRequestType;
    property DataKey: String read FDataKey write FDataKey;
    property EndPoint: String read FEndPoint write FEndPoint;
    property StatusCode: Integer read FStatusCode write FStatusCode;
    property QueryParams: String read FQueryParams write FQueryParams;
    property MemTable: TFDMemTable read FMemTable write SetMemTable;
    property SourceMemTable: TFDMemTable read FSourceMemTable write SetSourceMemTable;
    property SourceIgnoreFields: String read FSourceIgnoreFields write FSourceIgnoreFields;
    property SourceIgnoreBlanks: Boolean read FSourceIgnoreBlanks write FSourceIgnoreBlanks;
    property Tina4REST: TTina4REST read FTina4REST write SetTina4REST;
    property MasterSource: TTina4RESTRequest read FMasterSource write SetMasterSource;
    property ResponseBody: TStringList read FResponseBody write SetResponseBody;
    property RequestBody: TStringList read FRequestBody write SetRequestBody;
    property OnAddRecord :  TTina4AddRecordEvent read FOnAddRecord write FOnAddRecord;
    property OnExecuteDone: TTina4Event read FOnExecuteDone write FOnExecuteDone;
  end;

function SubmitJSONObjectToEndPoint(const Tina4REST: TTina4REST; EndPoint: String; JSONObject: TJSONObject): String; overload;
function SubmitJSONObjectToEndPoint(const Tina4REST: TTina4REST; EndPoint: String; JSONObject: TJSONObject; OnExecuteDone: TTina4Event): String; overload;

procedure Register;

implementation

function SubmitJSONObjectToEndPoint(const Tina4REST: TTina4REST; EndPoint: String; JSONObject: TJSONObject): String; overload;
begin
  var RestRequest: TTina4RESTRequest := TTina4RESTRequest.Create(nil);
  try
    RestRequest.Tina4REST := Tina4REST;
    RestRequest.RequestBody.Text := JSONObject.ToJSON;
    RestRequest.RequestType := TTina4RequestType.Post;
    RestRequest.EndPoint := EndPoint;
    RestRequest.ExecuteRESTCall;

    Result := RestRequest.ResponseBody.Text;
  finally
    RestRequest.Free;
  end;
end;

function SubmitJSONObjectToEndPoint(const Tina4REST: TTina4REST; EndPoint: String; JSONObject: TJSONObject; OnExecuteDone: TTina4Event): String; overload;
begin
  var RestRequest: TTina4RESTRequest := TTina4RESTRequest.Create(nil);
  try
    RestRequest.Tina4REST := Tina4REST;
    RestRequest.RequestBody.Text := JSONObject.ToJSON;
    RestRequest.RequestType := TTina4RequestType.Post;
    RestRequest.EndPoint := EndPoint;
    RestRequest.FreeOnAsyncExecute := True;
    RestRequest.ExecuteRESTCallAsync;

    RestRequest.OnExecuteDone := OnExecuteDone;
  finally
    RestRequest.Free;
  end;
end;


procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4RESTRequest]);
end;

{ TTina4RESTRequest }

constructor TTina4RESTRequest.Create(AOwner: TComponent);
begin
  inherited;
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

  procedure InjectMasterSourceParams(const MasterSource: TTina4RestRequest;
    var ResolvedEndPoint, ResolvedBody, ResolvedParams: String);
  var
    FieldRegEx: TRegEx;
    FieldName, FieldValue: String;
  begin
    if MasterSource = nil then Exit;
    if MasterSource.MemTable = nil then Exit;

    for var I := 0 to MasterSource.MemTable.FieldDefs.Count - 1 do
    begin
      FieldName := MasterSource.MemTable.FieldDefs[I].Name;
      FieldValue := MasterSource.MemTable.FieldByName(FieldName).AsString;
      FieldRegEx.Create('\{' + FieldName + '\}');

      ResolvedEndPoint := FieldRegEx.Replace(ResolvedEndPoint, FieldValue);
      ResolvedBody := FieldRegEx.Replace(ResolvedBody, FieldValue);
      ResolvedParams := FieldRegEx.Replace(ResolvedParams, FieldValue);
    end;
  end;

begin
  if not Assigned(FTina4REST) then
  begin
    {$IFDEF MSWINDOWS}
    ShowMessage('Assign a Tina4REST component to ' + Name);
    {$ENDIF}
    Exit;
  end;

  FResponseBody.Clear;
  Response := nil;

  var ResolvedEndPoint: String := FEndPoint;
  var ResolvedBody: String := FRequestBody.Text;
  var ResolvedParams: String := FQueryParams;

  InjectMasterSourceParams(FMasterSource, ResolvedEndPoint, ResolvedBody, ResolvedParams);

  if Assigned(FSourceMemTable) then
  begin
    var SourceJSON: TJSONObject := GetJSONFromTable(FSourceMemTable, 'records', FSourceIgnoreFields, FSourceIgnoreBlanks);
    try
      if SourceJSON.GetValue<TJSONArray>('records').Count = 1 then
        FRequestBody.Text := SourceJSON.GetValue<TJSONArray>('records').Items[0].ToJSON
      else
        FRequestBody.Text := SourceJSON.GetValue<TJSONArray>('records').ToJSON;
      ResolvedBody := FRequestBody.Text;
    finally
      SourceJSON.Free;
    end;
  end;

  if FRequestType = TTina4RequestType.Get then
    Response := FTina4REST.Get(FStatusCode, ResolvedEndPoint, ResolvedParams)
  else if FRequestType = TTina4RequestType.Delete then
    Response := FTina4REST.Delete(FStatusCode, ResolvedEndPoint, ResolvedParams)
  else if FRequestType = TTina4RequestType.Post then
    Response := FTina4REST.Post(FStatusCode, ResolvedEndPoint, ResolvedParams, ResolvedBody)
  else if FRequestType = TTina4RequestType.Patch then
    Response := FTina4REST.Patch(FStatusCode, ResolvedEndPoint, ResolvedParams, ResolvedBody)
  else if FRequestType = TTina4RequestType.Put then
    Response := FTina4REST.Put(FStatusCode, ResolvedEndPoint, ResolvedParams, ResolvedBody);

  try
    if Response = nil then
    begin
      FResponseBody.Text := '{"error": "Could not get a reply from the server!"}';
      if Assigned(FOnExecuteDone) then
        FOnExecuteDone(Self);
      Exit;
    end;

    FResponseBody.Text := Response.ToString;
    if FMemTable <> nil then
      PopulateMemTableFromJSON(FMemTable, DataKey, FResponseBody.Text, FIndexFieldNames, SyncMode, Self, FTransformResultToSnakeCase)
    else if Assigned(FOnExecuteDone) then
      FOnExecuteDone(Self);
  finally
    Response.Free;
  end;
end;

procedure TTina4RESTRequest.ExecuteRESTCallAsync;
begin
  var WorkerThread := TThread.CreateAnonymousThread(
    procedure
    begin
      ExecuteRESTCall;
      if FreeOnAsyncExecute then
        Free;
    end);
  WorkerThread.FreeOnTerminate := True;
  WorkerThread.Start;
end;


procedure TTina4RESTRequest.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FTina4REST then
      FTina4REST := nil
    else if AComponent = FMasterSource then
      FMasterSource := nil
    else if AComponent = FMemTable then
      FMemTable := nil
    else if AComponent = FSourceMemTable then
      FSourceMemTable := nil;
  end;
end;

procedure TTina4RESTRequest.SetTina4REST(const Value: TTina4REST);
begin
  if FTina4REST <> Value then
  begin
    if Assigned(FTina4REST) then
      FTina4REST.RemoveFreeNotification(Self);
    FTina4REST := Value;
    if Assigned(FTina4REST) then
      FTina4REST.FreeNotification(Self);
  end;
end;

procedure TTina4RESTRequest.SetMemTable(const Value: TFDMemTable);
begin
  if FMemTable <> Value then
  begin
    if Assigned(FMemTable) then
      FMemTable.RemoveFreeNotification(Self);
    FMemTable := Value;
    if Assigned(FMemTable) then
      FMemTable.FreeNotification(Self);
  end;
end;

procedure TTina4RESTRequest.SetSourceMemTable(const Value: TFDMemTable);
begin
  if FSourceMemTable <> Value then
  begin
    if Assigned(FSourceMemTable) then
      FSourceMemTable.RemoveFreeNotification(Self);
    FSourceMemTable := Value;
    if Assigned(FSourceMemTable) then
      FSourceMemTable.FreeNotification(Self);
  end;
end;

procedure TTina4RESTRequest.SetMasterSource(const Source: TTina4RESTRequest);
begin
  if FMasterSource <> Source then
  begin
    if Assigned(FMasterSource) then
      FMasterSource.RemoveFreeNotification(Self);
    if (Source <> nil) and (Source.Name <> Self.Name) then
    begin
      FMasterSource := Source;
      FMasterSource.FreeNotification(Self);
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
