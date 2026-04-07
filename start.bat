@echo off
title PooWoo SMP
set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk25.0.2_10"
set "PATH=%JAVA_HOME%\bin;%PATH%"
java -Xms16384M -Xmx16384M -XX:+UseZGC -jar server.jar --nogui
pause
