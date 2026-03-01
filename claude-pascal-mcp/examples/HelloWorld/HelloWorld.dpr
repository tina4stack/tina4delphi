program HelloWorld;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
