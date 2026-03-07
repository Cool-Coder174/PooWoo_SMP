# PooWoo SMP - Tunnel Setup

## Architecture

```
Friends (Internet) --> [VPS:25565] rathole relay --> [Your PC] rathole agent --> Minecraft:25565
```

## Local Testing (No VPS Needed)

Test that the tunnel concept works on your own machine:

### Terminal 1: Start Minecraft
```
.\start.bat
```

### Terminal 2: Start tunnel
```
cd rathole
python tunnel.py --forward --listen 25566 --target 127.0.0.1:25565
```

### Terminal 3: Test
Open Minecraft, add server `localhost:25566`. If you can connect, the tunnel works.

---

## Production Setup (With a VPS)

You need a cheap Linux VPS with a public IP. Options:
- Oracle Cloud free tier (free forever)
- Hetzner Cloud (~$4/month)
- DigitalOcean ($4/month)

### Step 1: Install rathole on the VPS

SSH into your VPS and run:

```bash
wget https://github.com/rathole-org/rathole/releases/download/v0.5.0/rathole-x86_64-unknown-linux-gnu.zip
unzip rathole-x86_64-unknown-linux-gnu.zip
chmod +x rathole
```

### Step 2: Create server config on the VPS

Create `server.toml`:

```toml
[server]
bind_addr = "0.0.0.0:2333"

[server.services.minecraft]
token = "PooWoo_SMP_2026_secret_token"
bind_addr = "0.0.0.0:25565"
```

IMPORTANT: Change the token to something unique and secret.

### Step 3: Run the relay on the VPS

```bash
./rathole server.toml
```

To keep it running after you disconnect SSH:
```bash
nohup ./rathole server.toml &
```

Or create a systemd service for auto-start.

### Step 4: Configure the agent on your PC

Edit `rathole/client.toml` and change `remote_addr` to your VPS IP:

```toml
[client]
remote_addr = "YOUR_VPS_PUBLIC_IP:2333"

[client.services.minecraft]
token = "PooWoo_SMP_2026_secret_token"
local_addr = "127.0.0.1:25565"
```

Tokens MUST match between server.toml and client.toml.

### Step 5: Run the agent on your PC

On Windows, you'll need rathole.exe. Since Windows Defender flags it, options:
1. Add a Defender exclusion (run PowerShell as Admin):
   ```powershell
   Add-MpExclusion -Path "C:\Users\isaac\Documents\Github\PooWoo_SMP\rathole"
   ```
   Then re-download and extract the binary.

2. Or use the Python tunnel as the agent (for a simple setup):
   ```
   python tunnel.py --forward --listen 25566 --target 127.0.0.1:25565
   ```
   Note: This only works as a local forwarder, not as a rathole client.

### Step 6: Friends connect

Friends add your VPS public IP as the server address in Minecraft:
```
YOUR_VPS_PUBLIC_IP
```

No port needed since the relay listens on the default 25565.

---

## VPS Firewall

Open these ports on your VPS:
- **2333 TCP** - rathole control channel
- **25565 TCP** - Minecraft player connections

On most cloud providers, this is done in the web dashboard under "Security Groups" or "Firewall".

## Security

- Always use a strong, unique token
- The token authenticates the agent to the relay
- Anyone who knows your token could tunnel their own services through your relay
