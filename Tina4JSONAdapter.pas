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
    FMasterOnExecuteDone: TTina4Event;
    procedure SetMasterSource(const Source: TTina4RESTRequest);
    procedure RunExecute(Sender: TObject);
  public
    procedure Execute;

  published
    property DataKey: String read FDataKey write FDataKey;
    property MemTable: TFDMemTable read FMemTable write FMemTable;
    property MasterSource: TTina4RESTRequest read FMasterSource write SetMasterSource;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4JSONAdapter]);
end;

{ TTina4JSONAdapter }

procedure TTina4JSONAdapter.Execute;
begin
  //Populates the target mem table
  if Assigned(FMemTable) and Assigned(FMasterSource) then
  begin
    PopulateMemTableFromJSON(FMemTable, FDataKey, FMasterSource.ResponseBody.Text);
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
  FMasterSource := Source;

  FMasterOnExecuteDone:= FMasterSource.OnExecuteDone;
  FMasterSource.OnExecuteDone := RunExecute;
end;

end.
