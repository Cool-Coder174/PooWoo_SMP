@echo off
title PooWoo SMP - Full Stack
set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk25.0.2_10"
set "PATH=%JAVA_HOME%\bin;C:\Users\isaac\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin;%PATH%"

echo =============================================
echo   PooWoo SMP - Minecraft + GCP Tunnel
echo =============================================
echo.

echo [1/3] Opening SSH tunnel to GCP relay...
echo       Friends connect to: 34.71.32.17
start "GCP Tunnel" "%~dp0start-tunnel-gcp.bat"
:: Give SSH tunnel time to establish before starting dependent services
timeout /t 8 /nobreak >nul

echo [2/3] Starting rathole client (Bedrock UDP + Voice Chat UDP)...
if exist "%~dp0rathole\rathole.exe" (
    start "Rathole Tunnel" /min "%~dp0rathole\rathole.exe" "%~dp0rathole\client.toml"
    echo       Bedrock UDP tunnel started on port 19132
    echo       Voice Chat UDP tunnel started on port 24454
) else (
    echo       [!] rathole.exe not found - UDP tunnels skipped
    echo       Download rathole and place rathole.exe in the rathole folder
)
timeout /t 2 /nobreak >nul

echo [3/3] Starting Minecraft server on port 25565...
echo.
echo =============================================
echo   CONNECTION INFO:
echo   Local:     localhost
echo   Friends:   34.71.32.17
echo   Java:      TCP 25565 via SSH tunnel
echo   Bedrock:   UDP 19132 via rathole tunnel
echo   Voice:     UDP 24454 via rathole tunnel
echo =============================================
echo.
java -Xms16384M -Xmx16384M -XX:+UseZGC -jar server.jar --nogui
pause
