unit Tina4HttpServer;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer;

type
  TTina4HttpServer = class(TIdHTTPServer)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); overload;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4HttpServer]);
end;

{ TTina4HttpServer }

constructor TTina4HttpServer.Create(AOwner: TComponent);
begin
  inherited;

  //Look for Tina4Route components belonging to the same project or parent to create a path map



end;

end.
