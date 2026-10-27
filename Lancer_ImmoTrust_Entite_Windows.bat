@echo off
setlocal
cd /d "%~dp0"

set "APP=%~dp0build\windows\x64\runner\Release\immotrust_entite.exe"
if not exist "%APP%" (
  echo ImmoTrust Entite is not built yet.
  echo Run Build_ImmoTrust_Entite_Windows.bat first.
  pause
  exit /b 1
)

start "" "%APP%"
