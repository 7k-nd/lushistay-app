@echo off
title Lancement de Elxau (Web Mobile)
color 0B

echo =======================================================
echo          LANCEMENT DE ELXAU SUR CHROME MOBILE
echo =======================================================
echo.
echo 1. Compilation de l'application Flutter...
echo 2. Ouverture de Google Chrome.
echo.
echo IMPORTANT : Quand Chrome s'ouvre :
echo - Appuie sur F12 (pour ouvrir la console)
echo - Appuie sur Ctrl + Shift + M (pour simuler un telephone)
echo.
echo Ne ferme pas cette fenetre noire pendant que tu testes !
echo.

flutter run -d chrome

echo.
pause
