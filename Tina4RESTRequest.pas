unit Tina4RESTRequest;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Tina4Core, Tina4REST, FMX.Dialogs, JSON;

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
    FRequestType: TTina4RequestType;
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
    property RequestType: TTina4RequestType read FRequestType write FRequestType;
    property DataKey: String read FDataKey write FDataKey;
    property EndPoint: String read FEndPoint write FEndPoint;
    property QueryParams: String read FQueryParams write FQueryParams;
    property MemTable: TFDMemTable read FMemTable write FMemTable;
    property Tina4REST: TTina4REST read FTina4REST write FTina4REST;
    property ResponseBody: TStringList read FResponseBody write SetResponseBody;
    property RequestBody: TStringList read FRequestBody write SetRequestBody;
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

procedure CreateRecord(JSONInfo: TJSONValue);
begin
  if (JSONInfo is TJSONObject) then
  begin
    if (not Initialized) then
    begin
      if Assigned(Self.FMemTable) and (Self.FMemTable.FieldDefs.Count = 0) then
      begin
        if (Self.FMemTable.Active) then
        begin
          Self.FMemTable.EmptyDataSet;
          Self.FMemTable.Close;
        end;
        GetFieldDefsFromJSONObject(TJSONObject(JSONInfo), TFDMemTable(Self.FMemTable));
        Self.FMemTable.CreateDataSet;
      end
        else
      if (not Self.FMemTable.Active) then
      begin
        Self.FMemTable.Open;
        Self.FMemTable.EmptyDataSet;
      end;

      Self.FMemTable.BeginBatch;
      Initialized := True;
    end;
    var JSONRecord := StrToJSONObject(JSONInfo.ToJSON);
    try
      Self.FMemTable.Append;
      for var Index : Integer := 0 to JSONRecord.Count-1 do
      begin
        var PairValue := JSONRecord.Pairs[Index].JsonValue.Value;
        Self.FMemTable.FieldByName(JSONRecord.Pairs[Index].JsonString.Value).AsString := PairValue;
      end;
      Self.FMemTable.Post;
    finally
      JSONRecord.Free;
    end;
  end;
end;


begin
  if Assigned(Self.FTina4REST) then
  begin
    Self.FResponseBody.Clear;
    Response := nil;

    if (Self.FRequestType = TTina4RequestType.Get) then
    begin
      Response := Self.FTina4REST.Get(Self.EndPoint, Self.QueryParams);
    end
      else
    if (Self.FRequestType = TTina4RequestType.Post) then
    begin
      Response := Self.FTina4REST.Post(Self.EndPoint, Self.QueryParams, Self.FRequestBody.Text);
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
          if (Self.FMemTable.Active) and (Self.FMemTable.FieldDefs.Count > 0) then
          begin
            if not Found then
            begin
              Self.FMemTable.EmptyDataSet;
            end;
          end;

          if (GetJSONFieldName(JSONValue.JsonString.ToString) = Self.DataKey) or (Self.DataKey = '') then
          begin
            if (JSONValue.JsonValue is TJSONArray) then
            begin
              Found := True;
              Self.DataKey := GetJSONFieldName(JSONValue.JsonString.ToString);

              Initialized := False;
              for var JSONInfo in TJSONArray(JSONValue.JsonValue) do
              begin
                CreateRecord(JSONInfo);
              end;
              Self.FMemTable.EndBatch;
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

          CreateRecord(Response);

          Self.FMemTable.EndBatch;

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

procedure TTina4RESTRequest.SetRequestBody(List: TStringList);
begin
  FRequestBody.Assign(List);
end;

procedure TTina4RESTRequest.SetResponseBody(List: TStringList);
begin
  FResponseBody.Assign(List);
end;

end.
