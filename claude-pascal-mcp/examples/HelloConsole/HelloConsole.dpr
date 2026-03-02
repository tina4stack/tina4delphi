program HelloConsole;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  Name: string;
begin
  try
    WriteLn('=== Pascal Console App ===');
    WriteLn('');
    Write('Enter your name: ');
    ReadLn(Name);
    WriteLn('Hello ' + Name + '!');
    WriteLn('');
    Write('Press Enter to exit...');
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
