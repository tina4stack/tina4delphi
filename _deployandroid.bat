@echo off
call "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\rsvars.bat"
msbuild Example\HtmlRender.dproj /t:Deploy /p:Config=Debug /p:Platform=Android /nologo /verbosity:minimal
