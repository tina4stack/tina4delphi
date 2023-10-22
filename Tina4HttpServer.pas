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
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4HttpServer]);
end;

end.
