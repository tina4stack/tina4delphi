unit Tina4JSONAdapter;

interface

uses
  System.SysUtils, System.Classes, JSON, Tina4Core, System.Net.URLClient, FMX.Dialogs, Tina4RESTRequest, FireDac.Comp.Client;

type
  TTina4JSONAdapter = class(TComponent)
  private
    FMasterSource: TTina4RESTRequest;
    FDataKey: String;
    FMemTable : TFDMemTable;
    FJSONData: TStringList;
    FSyncMode: TTina4RestSyncMode;
    FIndexFieldNames: String;
    FMasterOnExecuteDone: TTina4Event;
    procedure SetMasterSource(const Source: TTina4RESTRequest);
    procedure SetMemTable(const Value: TFDMemTable);
    procedure SetJSONData(const Value: TStringList);
    procedure RunExecute(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute;

  published
    property DataKey: String read FDataKey write FDataKey;
    property MemTable: TFDMemTable read FMemTable write SetMemTable;
    property JSONData: TStringList read FJSONData write SetJSONData;
    property SyncMode: TTina4RestSyncMode read FSyncMode write FSyncMode;
    property IndexFieldNames: String read FIndexFieldNames write FIndexFieldNames;
    property MasterSource: TTina4RESTRequest read FMasterSource write SetMasterSource;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4JSONAdapter]);
end;

{ TTina4JSONAdapter }

constructor TTina4JSONAdapter.Create(AOwner: TComponent);
begin
  inherited;
  FJSONData := TStringList.Create;
end;

destructor TTina4JSONAdapter.Destroy;
begin
  FJSONData.Free;
  inherited;
end;

procedure TTina4JSONAdapter.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FMasterSource then
      FMasterSource := nil
    else if AComponent = FMemTable then
      FMemTable := nil;
  end;
end;

procedure TTina4JSONAdapter.SetMemTable(const Value: TFDMemTable);
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

procedure TTina4JSONAdapter.SetJSONData(const Value: TStringList);
begin
  FJSONData.Assign(Value);
end;

procedure TTina4JSONAdapter.Execute;
begin
  if not Assigned(FMemTable) then
    Exit;

  //Populate from JSONData property if it has content
  if FJSONData.Text <> '' then
  begin
    PopulateMemTableFromJSON(FMemTable, FDataKey, FJSONData.Text, FIndexFieldNames, FSyncMode);
  end;

  //Populate from MasterSource if assigned
  if Assigned(FMasterSource) then
  begin
    var MasterJSONData: String :=  FMasterSource.ResponseBody.Text;

    //check if master source has a mem table
    if Assigned(FMasterSource.MemTable) then
    begin
      if (FMasterSource.MemTable.FieldDefs.IndexOf(FDataKey) = -1) then
      begin
        MasterJSONData := FMasterSource.ResponseBody.Text;
      end
        else
      begin
        if (FMasterSource.MemTable.FieldByName(FDataKey).AsString <> '') then
        begin
          if FMasterSource.MemTable.FieldByName(FDataKey).AsString[1] = '{' then
          begin
            MasterJSONData := '{"'+FDataKey+'": ['+FMasterSource.MemTable.FieldByName(FDataKey).AsString+']}';
          end
            else
          begin
            MasterJSONData := '{"'+FDataKey+'": '+FMasterSource.MemTable.FieldByName(FDataKey).AsString+'}';
          end;
        end;
      end;
    end;
    PopulateMemTableFromJSON(FMemTable, FDataKey, MasterJSONData, FIndexFieldNames, FSyncMode);
  end;
end;

procedure TTina4JSONAdapter.RunExecute(Sender: TObject);
begin
  //Call our Execute
  Execute;

  //Call the original on done event
  if Assigned(FMasterOnExecuteDone) then
  begin
    FMasterOnExecuteDone(Self);
  end;
end;

procedure TTina4JSONAdapter.SetMasterSource(const Source: TTina4RESTRequest);
begin
  if FMasterSource <> Source then
  begin
    if Assigned(FMasterSource) then
      FMasterSource.RemoveFreeNotification(Self);
    FMasterSource := Source;
    if Assigned(FMasterSource) then
    begin
      FMasterSource.FreeNotification(Self);
      FMasterOnExecuteDone := FMasterSource.OnExecuteDone;
      FMasterSource.OnExecuteDone := RunExecute;
    end;
  end;
end;

end.
