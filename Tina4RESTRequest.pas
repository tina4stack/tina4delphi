unit Tina4RESTRequest;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Tina4Core, Tina4REST, FMX.Dialogs;

type
  TTina4RESTRequest = class(TFDMemTable)
  private
    { Private declarations }
    FTina4REST: TTina4REST;
    FEndPoint: String;
    FQueryParams: String;
    FResponseJSON: TStringList;
    procedure SetResponseJSON(List: TStringList);
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure ExecuteRESTCall;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property EndPoint: String read FEndPoint write FEndPoint;
    property QueryParams: String read FQueryParams write FQueryParams;
    property Tina4REST: TTina4REST read FTina4REST write FTina4REST;
    property JSONResponse: TStringList read FResponseJSON write SetResponseJSON;
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
    var Response := Self.FTina4REST.Get(Self.EndPoint, Self.QueryParams);
    Self.JSONResponse.Text := Response.ToString;
  end
    else
  begin
    ShowMessage('Assign a Tina4REST component to '+Self.Name);
  end;
end;


procedure TTina4RESTRequest.SetResponseJSON(List: TStringList);
begin
  FResponseJSON.Assign(List);
end;

end.
