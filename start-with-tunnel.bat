@echo off
title PooWoo SMP - Full Stack
echo ===========================================
echo   PooWoo SMP - Minecraft + Tunnel
echo ===========================================
echo.

where java >nul 2>nul
if %errorlevel% neq 0 (
    set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk21.0.10_7"
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

echo [1/2] Starting tunnel (port 25566 -^> 25565)...
start "PooWoo Tunnel" cmd /c "cd rathole && python tunnel.py --forward --listen 25566 --target 127.0.0.1:25565"
timeout /t 2 /nobreak >nul

echo [2/2] Starting Minecraft server on port 25565...
echo.
echo ==========================================
echo   CONNECTION INFO:
echo   Direct:  localhost
echo   Tunnel:  localhost:25566
echo ==========================================
echo.
java -Xms4096M -Xmx4096M -jar server.jar --nogui
pause
