program Tina4DelphiExampleTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestTina4Twig in 'TestTina4Twig.pas',
  TestTina4Core in 'TestTina4Core.pas',
  TestTina4Components in 'TestTina4Components.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutDown := True;
  DUnitTestRunner.RunRegisteredTests;
  ReadLn;
end.

