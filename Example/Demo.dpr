program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  uDemo in 'uDemo.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
