@echo off
setlocal
cd /d "%~dp0"

set "FLUTTER_ROOT=%USERPROFILE%\flutter-sdk"
if not exist "%FLUTTER_ROOT%\bin\flutter.bat" set "FLUTTER_ROOT="
if exist "%FLUTTER_ROOT%\bin\flutter.bat" for %%I in ("%FLUTTER_ROOT%") do set "FLUTTER_ROOT=%%~sI"
if defined FLUTTER_ROOT set "BUILD_PATH=%FLUTTER_ROOT%\bin;%FLUTTER_ROOT%\bin\cache\dart-sdk\bin;%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0"
if defined FLUTTER_ROOT if exist "%ProgramFiles%\Git\cmd\git.exe" for %%I in ("%ProgramFiles%\Git\cmd") do set "GIT_BIN=%%~sI"
if defined FLUTTER_ROOT if defined GIT_BIN set "BUILD_PATH=%BUILD_PATH%;%GIT_BIN%"
if defined FLUTTER_ROOT set "PATH=%BUILD_PATH%"

echo Building ImmoTrust Entite web...
call flutter pub get
if errorlevel 1 exit /b %errorlevel%

call flutter build web --release -t lib/main_admin.dart
if errorlevel 1 exit /b %errorlevel%

echo.
echo Web build completed in build\web.
echo Deploying to Firebase Hosting (immotrust-entity)...
call firebase deploy --only hosting:entity --project b-ebooking
pause

