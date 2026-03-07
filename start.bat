@echo off
title PooWoo SMP

where java >nul 2>nul
if %errorlevel% neq 0 (
    set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk21.0.10_7"
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

java -Xms4096M -Xmx4096M -jar server.jar --nogui
pause
