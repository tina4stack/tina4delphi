program CrashSimTest;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  uCrashSimTest in 'uCrashSimTest.pas' {formCrashTest};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TformCrashTest, formCrashTest);
  Application.Run;
end.
