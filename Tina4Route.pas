unit Tina4Route;

interface

uses
  System.SysUtils, System.Classes;

type
  TTina4Route = class(TComponent)
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
  RegisterComponents('Tina4Delphi', [TTina4Route]);
end;

end.
