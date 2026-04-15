@echo off
call "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\rsvars.bat"
msbuild Example\Test\Tina4DelphiExampleTests.dproj /t:Build /p:Config=Debug /p:Platform=Win32 /p:DCC_Define="CONSOLE_TESTRUNNER" /nologo /verbosity:minimal
