@echo off
call "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\rsvars.bat"
cd /d "D:\projects\tina4delphi\Example"
MSBuild HtmlRender.dproj /t:Build;Deploy /p:Config=Debug /p:Platform=Android /v:minimal /nologo
echo EXITCODE=%ERRORLEVEL%
