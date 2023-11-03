unit Tina4RESTRequest;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Comp.DataSet,
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
    FResponseJSON: TStringList;
    FOnExecuteDone: TTina4Event;
    procedure SetResponseJSON(List: TStringList);
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
    property DataKey: String read FDataKey write FDataKey;
    property EndPoint: String read FEndPoint write FEndPoint;
    property QueryParams: String read FQueryParams write FQueryParams;
    property MemTable: TFDMemTable read FMemTable write FMemTable;
    property Tina4REST: TTina4REST read FTina4REST write FTina4REST;
    property JSONResponse: TStringList read FResponseJSON write SetResponseJSON;
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
  FResponseJSON := TStringList.Create;
end;

destructor TTina4RESTRequest.Destroy;
begin
  FResponseJSON.Free;
  inherited;
end;

procedure TTina4RESTRequest.ExecuteRESTCall;
begin
  if Assigned(Self.FTina4REST) then
  begin
    Self.JSONResponse.Clear;
    var Response := Self.FTina4REST.Get(Self.EndPoint, Self.QueryParams);
    try
      Self.JSONResponse.Text := Response.ToString;
      if Assigned(Self.FMemTable) then
      begin
        for var JSONValue in Response do
        begin
          if (GetJSONFieldName(JSONValue.JsonString.ToString) = Self.DataKey) or (Self.DataKey = '') then
          begin
            if (JSONValue.JsonValue is TJSONArray) then
            begin
              Self.DataKey := GetJSONFieldName(JSONValue.JsonString.ToString);

              if (Self.FMemTable.Active) and (Self.FMemTable.FieldDefs.Count > 0) then
              begin
                Self.FMemTable.EmptyDataSet;
              end;


              var Initialized := False;
              for var JSONInfo in TJSONArray(JSONValue.JsonValue) do
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
              Self.FMemTable.EndBatch;
              Self.FMemTable.First;



              if (Assigned(Self.FOnExecuteDone)) then
              begin
                Self.FOnExecuteDone(Self);
              end;


            end;
          end;
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

procedure TTina4RESTRequest.SetResponseJSON(List: TStringList);
begin
  FResponseJSON.Assign(List);
end;

end.
