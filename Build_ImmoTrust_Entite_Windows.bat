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
if defined FLUTTER_ROOT if exist "%LOCALAPPDATA%\Pub\Cache" for %%I in ("%LOCALAPPDATA%\Pub\Cache") do set "PUB_CACHE=%%~sI"

echo Building ImmoTrust Entite for Windows...
call flutter pub get
if errorlevel 1 goto :error

call flutter build windows --release -t lib/main_admin.dart
if errorlevel 1 goto :error

set "APP=build\windows\x64\runner\Release\immotrust_entite.exe"
if not exist "%APP%" (
  echo ERROR: The Windows build did not produce "%APP%".
  goto :error
)

for /f "tokens=2 delims=: " %%V in ('findstr /b "version:" pubspec.yaml') do set "APP_VERSION=%%V"
for /f "tokens=1 delims=+" %%V in ("%APP_VERSION%") do set "APP_VERSION=%%V"
if not defined APP_VERSION (
  echo ERROR: Could not read the app version from pubspec.yaml.
  goto :error
)

set "ISCC="
where ISCC.exe >nul 2>nul
if not errorlevel 1 set "ISCC=ISCC.exe"
if not defined ISCC if exist "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" set "ISCC=%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"
if not defined ISCC if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if not defined ISCC if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if not defined ISCC (
  echo ERROR: Inno Setup 6 was not found.
  echo Install Inno Setup 6, then run this script again.
  goto :error
)

if not exist "build\windows\installer" mkdir "build\windows\installer"
call "%ISCC%" /DMyAppVersion=%APP_VERSION% "%~dp0ImmoTrust_Entite.iss"
if errorlevel 1 goto :error

echo.
echo Build completed:
echo %~dp0build\windows\installer\ImmoTrust-Entite-Setup-%APP_VERSION%.exe
echo Copy this installer to the office PC and run it there.
pause
exit /b 0

:error
set "BUILD_ERROR=%errorlevel%"
if "%BUILD_ERROR%"=="0" set "BUILD_ERROR=1"
echo.
echo Build failed. Review the error above before retrying.
pause
exit /b %BUILD_ERROR%
