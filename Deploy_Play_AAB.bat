@echo off
setlocal
cd /d "%~dp0"
flutter pub get
if errorlevel 1 exit /b %errorlevel%
flutter build appbundle -t lib/main.dart --release
exit /b %errorlevel%