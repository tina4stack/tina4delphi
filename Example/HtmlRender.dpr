program HtmlRender;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  uHtmlRender in 'uHtmlRender.pas' {Form3};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
