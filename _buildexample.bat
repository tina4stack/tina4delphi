@echo off
call "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\rsvars.bat"
msbuild Example\HtmlRender.dproj /t:Build /p:Config=Debug /p:Platform=Win64 /nologo /verbosity:minimal
