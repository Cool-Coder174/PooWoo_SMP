@echo off
title PooWoo SMP - GCP Tunnel
call "%~dp0config.bat"

echo ============================================
echo   PooWoo SMP - SSH Reverse Tunnel to GCP
echo ============================================
echo.
echo Friends connect to: %GCP_RELAY_IP%
echo.
echo Keep this window open while playing!
echo Press Ctrl+C to disconnect the tunnel.
echo.
gcloud compute ssh %GCP_VM_NAME% --zone=%GCP_ZONE% --quiet --ssh-flag=-N --ssh-flag="-R 0.0.0.0:25565:localhost:25565"
pause
