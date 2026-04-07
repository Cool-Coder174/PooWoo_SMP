#!/bin/bash
set -e

RATHOLE_VERSION="0.5.0"
RATHOLE_URL="https://github.com/rathole-org/rathole/releases/download/v${RATHOLE_VERSION}/rathole-x86_64-unknown-linux-gnu.zip"
# To obtain: download the zip on a trusted machine, run sha256sum, and paste here.
RATHOLE_SHA256="3e7d0d0f365120cd3cd351d147d1a12ee960c8068b464d4dd533a3821873b80e"

cd /opt

wget -q "$RATHOLE_URL" -O rathole.zip
apt-get update -qq && apt-get install -y -qq unzip > /dev/null 2>&1

if [ -z "$RATHOLE_SHA256" ]; then
    echo "ERROR: RATHOLE_SHA256 is not set — refusing to run an unverified binary"
    echo "       Downloaded file hash: $(sha256sum rathole.zip | cut -d' ' -f1)"
    echo "       Verify this hash, then set RATHOLE_SHA256 in this script"
    exit 1
fi

echo "${RATHOLE_SHA256}  rathole.zip" | sha256sum -c - \
    || { echo "ERROR: checksum mismatch — download may be compromised"; exit 1; }

unzip -o rathole.zip -d /opt/rathole
rm -f rathole.zip
chmod +x /opt/rathole/rathole

TOKEN=$(curl -sf "http://metadata.google.internal/computeMetadata/v1/instance/attributes/rathole-token" \
  -H "Metadata-Flavor: Google") || { echo "ERROR: rathole-token metadata not set"; exit 1; }

cat > /opt/rathole/server.toml << TOML
[server]
bind_addr = "0.0.0.0:2333"

[server.services.bedrock]
token = "${TOKEN}"
bind_addr = "0.0.0.0:19132"
type = "udp"

[server.services.voicechat]
token = "${TOKEN}"
bind_addr = "0.0.0.0:24454"
type = "udp"
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
