#!/bin/bash
set -e

cd /opt

wget -q https://github.com/rathole-org/rathole/releases/download/v0.5.0/rathole-x86_64-unknown-linux-gnu.zip -O rathole.zip
apt-get update -qq && apt-get install -y -qq unzip > /dev/null 2>&1
unzip -o rathole.zip -d /opt/rathole
chmod +x /opt/rathole/rathole

cat > /opt/rathole/server.toml << 'TOML'
[server]
bind_addr = "0.0.0.0:2333"

[server.services.minecraft]
token = "REDACTED_TOKEN"
bind_addr = "0.0.0.0:25565"
TOML

cat > /etc/systemd/system/rathole.service << 'SERVICE'
[Unit]
Description=Rathole Relay for PooWoo SMP
After=network.target

[Service]
Type=simple
ExecStart=/opt/rathole/rathole /opt/rathole/server.toml
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable rathole
systemctl start rathole
