@echo off
call "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\rsvars.bat"
msbuild Example\HtmlRender.dproj /t:Help /p:Platform=Android /nologo 2>&1
echo ---
msbuild Example\HtmlRender.dproj /targets /p:Platform=Android /nologo 2>&1
