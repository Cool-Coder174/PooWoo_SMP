# PooWoo SMP

A PaperMC 26.1.1 Minecraft server with vanilla survival and BedWars.

## Quick Start

1. Make sure **Java 25** is installed and on your PATH.
2. Open a terminal in this folder.
3. Run:

```
.\start.bat
```

The server will start on port **25565** with 4GB RAM allocated.

## Server Info

| Property     | Value                          |
|--------------|--------------------------------|
| Software     | PaperMC 26.1.1 (build 29)     |
| Default Port | 25565                          |
| Game Mode    | Survival                       |
| Difficulty   | Normal                         |
| Max Players  | 20                             |
| RAM          | 4096MB min / 4096MB max        |

## Plugins

| Plugin          | Version | Purpose                        |
|-----------------|---------|--------------------------------|
| Multiverse-Core | 5.5.2   | Multiple world management      |
| BedWars         | 0.2.42.2| BedWars minigame               |
| CoreProtect     | 23.1    | Data logging & anti-griefing   |
| ViaVersion      | 5.9.0   | Cross-version client support   |

## Folder Structure

```
PooWoo_SMP/
  server.jar            PaperMC server
  start.bat             Startup script
  eula.txt              EULA acceptance
  server.properties     Server configuration
  plugins/              Plugin jars
  world/                Main survival world (generated on first boot)
  world_nether/         Nether dimension (generated)
  world_the_end/        End dimension (generated)
  logs/                 Server logs (generated)
```

---

## Server Administration

### Giving Yourself Admin (OP)

From the **server console** (the terminal where the server is running):

```
op <playername>
```

This gives full operator permissions. To remove:

```
deop <playername>
```

OP levels can be configured in `server.properties` with `op-permission-level` (1-4, default 4 = full access).

### Adding More Admins

From the console or in-game as an OP:

```
/op <playername>
```

All OPs are stored in `ops.json`. You can also edit this file directly while the server is stopped.

---

## Managing Players

### Banning Players

**Ban by name** (permanent):
```
/ban <player> [reason]
```

**Ban by IP** (blocks the IP address):
```
/ban-ip <player|ip> [reason]
```

**Temporary ban** (requires a plugin; PaperMC does not have built-in temp bans):
Consider adding EssentialsX for `/tempban`.

### Unbanning Players

```
/pardon <player>
/pardon-ip <ip>
```

Bans are stored in `banned-players.json` and `banned-ips.json`.

### Kicking Players

```
/kick <player> [reason]
```

### Whitelist

Enable the whitelist in `server.properties`:
```
white-list=true
```

Then manage it:
```
/whitelist add <player>
/whitelist remove <player>
/whitelist list
/whitelist on
/whitelist off
```

The whitelist is stored in `whitelist.json`.

---

## Game Rules

Game rules control world behavior. Change them with:

```
/gamerule <rule> <value>
```

### Commonly Used Game Rules

| Rule                     | Default | Description                              |
|--------------------------|---------|------------------------------------------|
| `keepInventory`          | false   | Keep items on death                      |
| `doDaylightCycle`        | true    | Sun moves across the sky                 |
| `doWeatherCycle`         | true    | Weather changes naturally                |
| `doMobSpawning`          | true    | Mobs spawn naturally                     |
| `mobGriefing`            | true    | Mobs can break/change blocks             |
| `doFireTick`             | true    | Fire spreads                             |
| `pvp`                    | true    | Players can damage each other (also in server.properties) |
| `naturalRegeneration`    | true    | Health regenerates when food is full     |
| `doInsomnia`             | true    | Phantoms spawn when you don't sleep      |
| `playersSleepingPercentage` | 100  | % of players needed to skip night (set to 1 for single-player skip) |
| `announceAdvancements`   | true    | Broadcast when players earn advancements |
| `showDeathMessages`      | true    | Show death messages in chat              |
| `randomTickSpeed`        | 3       | Speed of crop growth, leaf decay, etc.   |
| `spawnRadius`            | 10      | Radius around spawn where players appear |
| `maxEntityCramming`      | 24      | Max entities in one space before damage  |

**Examples:**
```
/gamerule keepInventory true
/gamerule playersSleepingPercentage 50
/gamerule doInsomnia false
```

---

## Difficulty and Game Mode

**Set difficulty** (peaceful, easy, normal, hard):
```
/difficulty <level>
```

**Change a player's game mode:**
```
/gamemode survival <player>
/gamemode creative <player>
/gamemode spectator <player>
/gamemode adventure <player>
```

---

## World Management (Multiverse-Core)

### Basic Commands

**List all worlds:**
```
/mv list
```

**Create a new world:**
```
/mv create <name> <environment>
```
Environments: `normal`, `nether`, `the_end`

**Create a flat world (good for building arenas):**
```
/mv create <name> normal -t FLAT
```

**Teleport to a world:**
```
/mv tp <worldname>
```

**Delete a world:**
```
/mv remove <worldname>
/mv delete <worldname>
/mv confirm
```

**Set world spawn:**
```
/mv setspawn
```

**Set world game mode:**
```
/mv modify set gamemode creative <worldname>
```

### World Properties

Edit per-world settings:
```
/mv modify set <property> <value> <worldname>
```

Properties include: `pvp`, `difficulty`, `gamemode`, `animals`, `monsters`, `hunger`.

---

## BedWars Setup

BedWars requires **manual in-game setup** for arenas. The plugin is installed and loaded, but arenas must be built and configured by an admin.

### Step 1: Create a BedWars World

```
/mv create bedwars normal -t FLAT
/mv tp bedwars
```

### Step 2: Build Your Arena

Build (or use WorldEdit to import) a BedWars map with:
- Team islands with beds
- A center island
- Bridges or gaps between islands
- Resource spawner locations

### Step 3: Configure the Arena

```
/bw admin <arena> add
```

Set the arena boundaries (stand at each corner):
```
/bw admin <arena> pos1
/bw admin <arena> pos2
```

Set spawns:
```
/bw admin <arena> lobby
/bw admin <arena> spec
```

Add teams:
```
/bw admin <arena> team add Red RED 2
/bw admin <arena> team add Blue BLUE 2
/bw admin <arena> team spawn Red
/bw admin <arena> team spawn Blue
/bw admin <arena> team bed Red
/bw admin <arena> team bed Blue
```

Add item shop NPCs (stand where you want the shop):
```
/bw admin <arena> store add
```

Set game parameters:
```
/bw admin <arena> minplayers 2
/bw admin <arena> time 600
/bw admin <arena> save
```

### Step 4: Play

Players join with:
```
/bw join <arena>
```

Leave with:
```
/bw leave
```

### BedWars Admin Commands

| Command                          | Description                  |
|----------------------------------|------------------------------|
| `/bw admin <a> add`             | Create new arena             |
| `/bw admin <a> pos1` / `pos2`   | Set arena boundaries         |
| `/bw admin <a> lobby`           | Set lobby spawn              |
| `/bw admin <a> spec`            | Set spectator spawn          |
| `/bw admin <a> team add`        | Add a team                   |
| `/bw admin <a> team spawn`      | Set team spawn               |
| `/bw admin <a> team bed`        | Set team bed location        |
| `/bw admin <a> store add`       | Place item shop              |
| `/bw admin <a> save`            | Save arena config            |
| `/bw admin <a> minplayers <n>`  | Minimum players to start     |
| `/bw admin <a> time <s>`        | Game duration in seconds     |

Full documentation: https://docs.screamingsandals.org/BedWars/latest/

---

## Server Configuration Reference

Key settings in `server.properties`:

| Setting                    | Current Value | What It Does                          |
|----------------------------|---------------|---------------------------------------|
| `server-port`              | 25565         | Port the server listens on            |
| `motd`                     | PooWoo SMP... | Message shown in server browser       |
| `max-players`              | 20            | Maximum concurrent players            |
| `difficulty`               | normal        | Default difficulty                    |
| `gamemode`                 | survival      | Default game mode                     |
| `online-mode`              | true          | Require legitimate Minecraft accounts |
| `view-distance`            | 10            | Chunk render distance                 |
| `spawn-protection`         | 0             | Blocks around spawn only OPs can edit |
| `enable-command-block`     | true          | Allow command blocks                  |
| `white-list`               | false         | Require whitelist to join             |
| `pvp`                      | true          | Player vs player combat               |

To change these, edit `server.properties` and restart the server, or use in-game commands where available.

---

## Useful Console Commands

| Command                        | Description                           |
|--------------------------------|---------------------------------------|
| `stop`                         | Gracefully shut down the server       |
| `save-all`                     | Force-save all worlds                 |
| `say <message>`               | Broadcast a message to all players    |
| `tp <player> <x> <y> <z>`     | Teleport a player                     |
| `give <player> <item> [count]` | Give items to a player                |
| `time set day`                 | Set time to day                       |
| `weather clear`                | Clear weather                         |
| `list`                         | Show online players                   |
| `seed`                         | Show the world seed                   |

---

## Letting Friends Connect

### Local Network (Same Wi-Fi)

Friends on the same network connect with your **local IP**:
```
ipconfig
```
Look for `IPv4 Address` (e.g., `192.168.1.100`). They connect to `192.168.1.100:25565`.

### Over the Internet (GCP Tunnel)

This server uses a free GCP e2-micro VM as an SSH relay. The Minecraft server runs on your PC; the VM just forwards traffic.

**How it works:**
```
Friends --> GCP VM (34.71.32.17:25565) --> SSH tunnel --> Your PC (localhost:25565)
```

**Tell friends to connect to: `34.71.32.17`**

**Starting everything:**

Option A -- One click (both server + tunnel):
```
.\start-with-tunnel.bat
```

Option B -- Separate windows (more control):
```
# Terminal 1: Start Minecraft
.\start.bat

# Terminal 2: Start tunnel
.\start-tunnel-gcp.bat
```

**GCP resources:**
- Project: `poowoo-smp-relay`
- VM: `poowoo-relay` (e2-micro, us-central1-a)
- Cost: $0 (free tier)

### Troubleshooting

- **Firewall**: Windows should prompt to allow Java. If blocked, go to Windows Defender Firewall > Allow an app > add `java.exe`.
- **"Connection refused"**: Server isn't running, or tunnel isn't open. Both must be running.
- **"Outdated client/server"**: Players must use Minecraft Java Edition **1.21.11**.
- **Tunnel drops**: The SSH session may disconnect after idle time. Restart `start-tunnel-gcp.bat`.
- **VM stopped**: Check with `gcloud compute instances list --project=poowoo-smp-relay`. Start with `gcloud compute instances start poowoo-relay --zone=us-central1-a`.

---

## Backups

Regularly back up your world data. Stop the server first (or use `save-all` then `save-off`), then copy:
- `world/`
- `world_nether/`
- `world_the_end/`
- `plugins/` (contains arena configs and player data)
