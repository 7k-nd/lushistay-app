@echo off
title Lancement de Elxau (Sur Telephone)
color 0A

echo =======================================================
echo     LANCEMENT DE ELXAU POUR TEST SUR TELEPHONE
echo =======================================================
echo.
echo 1. Assurez-vous que votre telephone et PC sont sur le meme Wi-Fi.
echo 2. Regardez votre telephone et tapez l'adresse IP qui va s'afficher ci-dessous.
echo.

:: Récupération de l'adresse IP locale
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
)
:: Nettoyer les espaces de l'IP
set IP=%IP: =%

echo ----------------------------------------------------
echo L'application sera bientot accessible sur votre telephone a :
echo 👉 http://%IP%:8080
echo ----------------------------------------------------
echo.
echo Chargement en cours (ne fermez pas cette fenetre)...
echo.

flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

echo.
pause
