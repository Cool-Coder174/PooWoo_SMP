@echo off
title PooWoo SMP - Full Stack
echo =============================================
echo   PooWoo SMP - Minecraft + GCP Tunnel
echo =============================================
echo.

set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk21.0.10_7"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo [1/2] Opening SSH tunnel to GCP relay...
echo       Friends connect to: 34.71.32.17
start "GCP Tunnel" "%~dp0start-tunnel-gcp.bat"
timeout /t 8 /nobreak >nul

echo [2/2] Starting Minecraft server on port 25565...
echo.
echo =============================================
echo   CONNECTION INFO:
echo   Local:   localhost
echo   Friends: 34.71.32.17
echo =============================================
echo.
java -Xms4096M -Xmx4096M -jar server.jar --nogui
pause
