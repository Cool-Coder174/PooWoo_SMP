@echo off
title PooWoo SMP - GCP Tunnel
set "PATH=C:\Users\isaac\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin;%PATH%"

echo ============================================
echo   PooWoo SMP - SSH Reverse Tunnel to GCP
echo ============================================
echo.
echo Friends connect to: 34.71.32.17
echo.
echo Keep this window open while playing!
echo Press Ctrl+C to disconnect the tunnel.
echo.
gcloud compute ssh poowoo-relay --zone=us-central1-a --quiet --ssh-flag=-N --ssh-flag="-R 0.0.0.0:25565:localhost:25565"
pause
