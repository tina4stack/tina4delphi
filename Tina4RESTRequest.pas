unit Tina4RESTRequest;

interface

uses
  System.SysUtils, System.Variants, System.Generics.Collections, System.Classes, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Tina4Core, Tina4REST, FMX.Dialogs, JSON, System.RegularExpressions;

type
  TTina4RESTRequest = class(TComponent)
  private
    { Private declarations }
    FMemTable: TFDMemTable;
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
  Initialized: Boolean;

procedure CreateOrUpdateRecord(JSONInfo: TJSONValue);
begin
  if (JSONInfo is TJSONObject) then
  begin
    var JSONRecord := StrToJSONObject(JSONInfo.ToJSON);
     
    if (not Initialized) then
    begin
      if Assigned(Self.FMemTable) and ((Self.FMemTable.FieldDefs.Count = 0) or (Self.FMemTable.FieldDefs.Count <> JSONRecord.Count)) then
      begin       
        if (Self.FMemTable.Active) then
        begin
          if Self.FSyncMode = Clear then
          begin
            Self.FMemTable.Close;
          end;
        end;
        
        if Self.FMemTable.Fields.Count = 0 then
        begin
          GetFieldDefsFromJSONObject(TJSONObject(JSONInfo), TFDMemTable(Self.FMemTable));
          Self.FMemTable.CreateDataSet;
        end;
      end;

      if (not Self.FMemTable.Active) then
      begin
        Self.FMemTable.Open;
        if Self.FSyncMode = Clear then
        begin
          Self.FMemTable.EmptyDataSet;
        end;
      end;

      //Only do batching when we don't have to refresh or update records
      if (not Assigned(Self.OnAddRecord)) then
      begin
        Self.FMemTable.BeginBatch;
      end;
      Initialized := True;
    end;

    if (Self.IndexFieldNames = '') and (Self.MemTable.FieldDefs.Count > 0) then
    begin
      Self.IndexFieldNames := Self.MemTable.FieldDefs[0].Name; 
    end;

    var FilterState : Boolean := Self.MemTable.Filtered;
    var Filter : String := Self.MemTable.Filter;
   
    try
      if Self.FSyncMode = Clear then
      begin
        Self.FMemTable.Append;
      end
        else
      begin
        var IndexStringList: TStringList;
        IndexStringList := TStringList.Create('"', ',');
        IndexStringList.DelimitedText := Self.IndexFieldNames;

        Self.FMemTable.Filtered := False;
        Self.FMemTable.Filter := '';

        for var I := 0 to IndexStringList.Count-1 do
        begin  
          if (Self.FMemTable.Filter <> '') then
          begin
            Self.FMemTable.Filter := Self.FMemTable.Filter +' and ';
          end;
          Self.FMemTable.Filter := Self.FMemTable.Filter + IndexStringList[I] +' = '+QuotedStr(JSONRecord.GetValue<string>(IndexStringList[I])); 
        end;

        Self.FMemTable.Filtered := True;

        if (Self.FMemTable.RecNo = 0) then   //No record found
        begin
          Self.FMemTable.Append;
        end
          else
        begin  
          Self.FMemTable.Edit;
        end;        
      end;
      
      for var Index : Integer := 0 to JSONRecord.Count-1 do
      begin
        var PairValue : String;
        if (JSONRecord.Pairs[Index].JsonValue is TJSONObject) or (JSONRecord.Pairs[Index].JsonValue is TJSONArray) then
        begin
          PairValue := JSONRecord.Pairs[Index].JsonValue.ToString;
        end
          else
        begin
          PairValue := JSONRecord.Pairs[Index].JsonValue.Value;
        end;

        var KeyIndex := Self.MemTable.FieldDefs.IndexOf(JSONRecord.Pairs[Index].JsonString.Value);

        if KeyIndex >= 0 then
        begin
          Self.FMemTable.FieldByName(JSONRecord.Pairs[Index].JsonString.Value).AsString := PairValue;
        end;
      end;



      if Assigned(Self.FOnAddRecord) then
      begin
        FOnAddRecord(Self, Self.FMemTable);
      end;

      Self.FMemTable.Post;

      Self.FMemTable.Filtered := False;
      Self.MemTable.Filter := Filter;
      Self.MemTable.Filtered := FilterState;
    finally
      JSONRecord.Free;
    end;
  end;
end;


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
    Self.FResponseBody.Clear;
    Response := nil;

    var EndPoint : String := Self.EndPoint;
    var RequestBody : String := Self.FRequestBody.Text;
    var QueryParams : String := Self.QueryParams;


    InjectMasterSourceParams(Self.FMasterSource, EndPoint, RequestBody, QueryParams);


    if (Self.FRequestType = TTina4RequestType.Get) then
    begin
      Response := Self.FTina4REST.Get(EndPoint, QueryParams);
    end
      else
    if (Self.FRequestType = TTina4RequestType.Delete) then
    begin
      Response := Self.FTina4REST.Delete(EndPoint, QueryParams);
    end
      else
    if (Self.FRequestType = TTina4RequestType.Post) then
    begin
      Response := Self.FTina4REST.Post(EndPoint, QueryParams, RequestBody);
    end
      else
    if (Self.FRequestType = TTina4RequestType.Patch) then
    begin
      Response := Self.FTina4REST.Patch(EndPoint, QueryParams, RequestBody);
    end
      else
    if (Self.FRequestType = TTina4RequestType.Put) then
    begin
      Response := Self.FTina4REST.Put(EndPoint, QueryParams, RequestBody);
    end;

    try
      if (Response = nil) then
      begin
        Self.FResponseBody.Text := '{"error": "Check the response from the server, something bad happened!"}';
        if (Assigned(Self.FOnExecuteDone)) then
        begin
          Self.FOnExecuteDone(Self);
        end;
        Exit;
      end;

      Self.FResponseBody.Text := Response.ToString;
      if Assigned(Self.FMemTable) then
      begin
        var Found := False;
        for var JSONValue in Response do
        begin
          if (Self.DataKey = '') and (GetJSONFieldName(JSONValue.JsonString.ToString) = 'response') then
          begin
            Self.DataKey := 'response';
          end;
        
          if (Self.FMemTable.Active) and (Self.FMemTable.FieldDefs.Count > 0) then
          begin
            if not Found and (Self.FSyncMode = Clear) then 
            begin
              Self.FMemTable.EmptyDataSet;
            end;
          end;

          if (GetJSONFieldName(JSONValue.JsonString.ToString) = Self.DataKey) then
          begin
            if (JSONValue.JsonValue is TJSONArray) then
            begin
              Found := True;
              
              Initialized := False;
              for var JSONInfo in TJSONArray(JSONValue.JsonValue) do
              begin
                CreateOrUpdateRecord(JSONInfo);
              end;
              //Only do batching when we don't have to refresh or update records
              if (not Assigned(Self.OnAddRecord)) then
              begin
                Self.FMemTable.EndBatch;
              end;
              Self.FMemTable.First;

              if (Assigned(Self.FOnExecuteDone)) then
              begin
                Self.FOnExecuteDone(Self);
              end;
            end;
          end;
        end;

        //Convert the object that is returned
        if not Found then
        begin
          Initialized := False;

          CreateOrUpdateRecord(Response);

          if (not Assigned(Self.OnAddRecord)) then
          begin
            Self.FMemTable.EndBatch;
          end;

          if (Assigned(Self.FOnExecuteDone)) then
          begin
            Self.FOnExecuteDone(Self);
          end;
        end;
      end
        else
      begin
        if (Assigned(Self.FOnExecuteDone)) then
        begin
          Self.FOnExecuteDone(Self);
        end;
      end;
    finally
      Response.Free;
    end;
  end
    else
  begin
    ShowMessage('Assign a Tina4REST component to '+Self.Name);
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
