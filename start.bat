@echo off
title PooWoo SMP
call "%~dp0config.bat"
java -Xms%SERVER_RAM%M -Xmx%SERVER_RAM%M -XX:+UseZGC -jar %SERVER_JAR% --nogui
pause
