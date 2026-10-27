@echo off
setlocal
cd /d "%~dp0"

echo ====================================================
echo        Lancement de LushiStay Web Demo (2026)
echo ====================================================

start "" cmd /c "node server.js"
timeout /t 2 >nul
start "" "http://localhost:5050"
start "" "C:\Program Files (x86)\cloudflared\cloudflared.exe" tunnel --url http://localhost:5050

echo Serveur demarre !
pause
