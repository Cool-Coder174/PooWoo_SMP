@echo off
title PooWoo SMP Tunnel (port 25566 -> 25565)
echo Starting tunnel: localhost:25566 -^> localhost:25565
echo.
py -3 tunnel.py --forward --listen 25566 --target 127.0.0.1:25565
pause
