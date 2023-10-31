unit Tina4Route;

interface

uses
  System.SysUtils, System.Classes, Tina4Core, Tina4Webserver;

type
  TTina4Route = class(TComponent)
  private
    { Private declarations }
  protected
    { Protected declarations }
    FOnEndPointExecute : TTina4EndpointExecute;
    FEndPoint: String;
    FCRUDRoute: Boolean;
    FWebServer: TTina4WebServer;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property OnExecute: TTina4EndpointExecute read FOnEndPointExecute write FOnEndPointExecute;
    property EndPoint: String read FEndpoint write FEndpoint;
    property CRUD: Boolean read FCRUDRoute write FCRUDRoute;
    property WebServer: TTina4WebServer read FWebServer write FWebServer;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4Route]);
end;

{ TTina4Route }

constructor TTina4Route.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

destructor TTina4Route.Destroy;
begin

  inherited;
end;

end.
