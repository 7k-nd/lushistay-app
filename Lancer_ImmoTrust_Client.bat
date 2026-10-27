@echo off
title ImmoTrust - Client
color 0B
echo =======================================================
echo          IMMOTRUST - APPLICATION CLIENT
echo =======================================================
echo.
set "FLUTTER_ROOT=%USERPROFILE%\flutter-sdk"
if not exist "%FLUTTER_ROOT%\bin\flutter.bat" set "FLUTTER_ROOT="
if exist "%FLUTTER_ROOT%\bin\flutter.bat" for %%I in ("%FLUTTER_ROOT%") do set "FLUTTER_ROOT=%%~sI"
if defined FLUTTER_ROOT set "BUILD_PATH=%FLUTTER_ROOT%\bin;%FLUTTER_ROOT%\bin\cache\dart-sdk\bin;%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0"
if defined FLUTTER_ROOT if exist "%ProgramFiles%\Git\cmd\git.exe" for %%I in ("%ProgramFiles%\Git\cmd") do set "GIT_BIN=%%~sI"
if defined FLUTTER_ROOT if defined GIT_BIN set "BUILD_PATH=%BUILD_PATH%;%GIT_BIN%"
if defined FLUTTER_ROOT set "PATH=%BUILD_PATH%"

echo Lancement du serveur Web et ouverture dans Google Chrome...
echo URL : http://localhost:8080
echo.
start http://localhost:8080
call flutter run -d web-server --web-port=8080 -t lib/main.dart
pause
