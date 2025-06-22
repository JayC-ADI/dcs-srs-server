# DCS-SRS Voice Server (DCS Simple Radio Standalone)

A high-performance, containerized DCS-SRS voice server implementation designed for Digital Combat Simulator (DCS) radio communications. This Docker image enables easy deployment of DCS-SRS servers to high-speed VMs and VPS instances, making voice communication setup simpler for DCS groups and communities.

## About This Repository

This repository provides a Docker image for the Linux DCS-SRS server, allowing end users and groups to easily deploy working SRS servers to virtual machines and VPS instances. This containerized approach simplifies server setup and makes reliable voice communication more accessible for DCS communities.

**Special Thanks**: Atlas Defense Industries ([https://adi.sc/](https://adi.sc/)) for helping to put together and test this Docker setup.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Server Features](#server-features)
- [REST API](#rest-api)
- [Channel Presets](#channel-presets)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

The DCS-SRS Voice Server is a command-line application that provides realistic radio communication services for Digital Combat Simulator (DCS) multiplayer environments. It simulates military aviation radio systems with realistic frequency management, radio effects, and communication protocols.

### Key Components

- **SRS-Server-Commandline**: The main executable voice server application
- **Docker Container**: Containerized deployment solution for easy hosting
- **Radio Simulation**: Realistic military radio frequency and effect simulation
- **Voice Processing**: Real-time voice communication with radio effects
- **REST API**: Server management and client control via HTTP API
- **Server-Side Presets**: Optional channel presets managed by the server

## Features

- 🎧 **Realistic Radio Simulation**: Authentic military aviation radio communication
- 📡 **Multi-Frequency Support**: Support for multiple radio frequencies and channels
- 🔊 **Voice Effects**: Realistic radio static, interference, and transmission effects
- 🐳 **Docker Support**: Fully containerized deployment for easy server hosting
- 🔧 **Configurable**: Flexible configuration for different server scenarios
- 📊 **Monitoring**: Built-in server monitoring and connection tracking
- 🔒 **Secure**: Encrypted voice communication and server authentication
- 🌐 **Multi-Client**: Support for multiple simultaneous DCS clients
- ⚡ **Low Latency**: Optimized for real-time voice communication
- 🛠️ **REST API**: Remote server management and client administration
- 📻 **Server-Side Presets**: Centralized channel preset management
- 📝 **Enhanced Logging**: Improved transmission logging with CSV format
- 🚫 **IP Banning**: Automatic IP ban management with banned.txt file

## Prerequisites

- Docker 20.10 or later
- Docker Compose v2.0 or later

## Quick Start

### Using Docker Compose (Strongly Recommended)

The docker-compose method is the preferred way to run DCS-SRS server as it provides:
- Automatic restart policies
- Proper volume mounting for logs and config
- Easy configuration management
- Better container lifecycle management

1. **Download the docker-compose.yml file**
   ```bash
   wget https://raw.githubusercontent.com/JayC-ADI/dcs-srs-server/main/docker-compose.yml
   ```

2. **Start the service**
   ```bash
   docker-compose up -d
   ```

The service will start automatically using the default configuration. You can modify the environment variables directly in the docker-compose.yml file.

### Using Docker Run with .env file (Alternative)

If you prefer to use docker run with an .env file:

1. **Download the .env.example file**
   ```bash
   wget https://raw.githubusercontent.com/JayC-ADI/dcs-srs-server/main/.env.example -O .env
   ```

2. **Edit the .env file to customize your server**
   ```bash
   nano .env
   ```

3. **Run with docker run**
   ```bash
   docker run -d \
     --name dcs-srs-server \
     -p 5002:5002/tcp \
     -p 5002:5002/udp \
     --env-file .env \
     jaycadi/dcs-srs-server:latest
   ```

**Note**: Port 5002 requires both TCP and UDP protocols for proper DCS-SRS communication.

## Configuration

The DCS-SRS server can be configured using environment variables. The easiest way is to modify the docker-compose.yml file directly, but you can also use a .env file if using docker run.

### Docker Compose Configuration (Recommended)

The included `docker-compose.yml` file provides a complete setup with all available configuration options:

```yaml
# Docker Compose configuration for DCS-SRS (Digital Combat Simulator - Simple Radio Standalone) server
# This file defines how to run the SRS server in a Docker container
version: '3.8'

services:
  dcs-srs:
    # Container name - change this if you want a different name for your container
    container_name: dcs-srs
    
    # Docker image to use - only change if you need a different version
    image: jaycadi/dcs-srs-server:2.2.0.5
    
    deploy:
      # Number of container instances to run (1 = single server, 0 = disabled)
      replicas: 1  # Change to 0 or any number to scale
      restart_policy:
        # Restart container automatically if it crashes
        condition: any
    
    ports:
      # Port mapping: "host_port:container_port/protocol"
      # Change "5002" on the left to use a different port on your host machine
      - "5002:5002/udp"  # UDP port for voice communication
      - "5002:5002/tcp"  # TCP port for client connections and data
      - "8080:8080/tcp"  # REST API port (only expose if using REST API)
    
    # WORKING DIRECTORY & ENTRYPOINT
    working_dir: /opt/srs
    entrypoint: ["/opt/srs/entrypoint.sh"]
    
    volumes:
      # Mount host Presets directory to allow user-managed presets
      # Change "/docker/dcs-srs/Presets" to your preferred host directory path
      - "/docker/dcs-srs/Presets:/opt/srs/Presets"
    
    environment:
      # ===== GENERAL RADIO SETTINGS =====
      
      # Log all radio transmissions to file (true/false)
      # Set to "true" if you want to record all voice communications
      TRANSMISSION_LOG_ENABLED: "false"
      
      # Export connected clients list to JSON file (true/false)
      # Useful for external applications that need to know who's connected
      CLIENT_EXPORT_ENABLED: "false"
      
      # Enable server-side channel presets (true/false)
      # Set to "true" to provide predefined radio presets to clients
      SERVER_PRESETS_ENABLED: "false"
      
      # Enable HTTP server for SRS management endpoints (true/false)
      # Set to "true" to enable HTTP API for client management
      HTTP_SERVER_ENABLED: "true"
      
      # Port for the HTTP server (must match exposed port above, e.g., 8080:8080)
      # REST API port (only used if HTTP_SERVER_ENABLED is true)
      HTTP_SERVER_PORT: "8080"
      
      # ===== ADVANCED RADIO SETTINGS =====
      
      # Export data for LotATC (Situational Awareness tool) (true/false)
      LOTATC_EXPORT_ENABLED: "false"
      
      # Frequencies that are always available for testing (comma-separated MHz)
      # Add frequencies here that users can use to test their radio setup
      TEST_FREQUENCIES: "247.2,120.3"
      
      # Frequencies available in the lobby before joining a mission (comma-separated MHz)
      # Users can communicate on these frequencies while waiting
      GLOBAL_LOBBY_FREQUENCIES: "248.22"
      
      # Enable External AWACS mode for server-side radio management (true/false)
      # Set to "true" if you want the server to manage radios instead of DCS
      EXTERNAL_AWACS_MODE: "true"
      
      # Prevent enemy teams from hearing each other's radio (true/false)
      # Set to "true" for realistic military simulation
      COALITION_AUDIO_SECURITY: "false"
      
      # Prevent spectators from hearing any radio communications (true/false)
      # Set to "true" if spectators shouldn't hear mission communications
      SPECTATORS_AUDIO_DISABLED: "false"
      
      # Enable Line of Sight radio limitations (true/false)
      # Set to "true" for realistic radio range based on terrain and distance
      LOS_ENABLED: "false"
      
      # Enable distance-based radio range limitations (true/false)
      # Set to "true" for realistic radio range based on distance only
      DISTANCE_ENABLED: "false"
      
      # Enable real-world radio transmission effects (true/false)
      # Adds realistic radio static and effects to transmissions
      IRL_RADIO_TX: "false"
      
      # Enable real-world radio interference effects (true/false)
      # Adds realistic interference when receiving radio
      IRL_RADIO_RX_INTERFERENCE: "false"
      
      # Allow more than 10 radio presets per aircraft (true/false)
      # Set to "true" for expanded radio capabilities
      RADIO_EXPANSION: "true"
      
      # Allow encrypted radio communications (true/false)
      # Enables encryption features for secure communications
      ALLOW_RADIO_ENCRYPTION: "true"
      
      # Force all radios to use encryption (true/false)
      # Set to "true" if all communications must be encrypted
      STRICT_RADIO_ENCRYPTION: "false"
      
      # Show number of users tuned to each frequency (true/false)
      # Displays user count next to frequencies in the radio overlay
      SHOW_TUNED_COUNT: "true"
      
      # Override individual radio effects settings (true/false)
      # Forces server radio effects settings for all clients
      RADIO_EFFECT_OVERRIDE: "false"
      
      # Show the name of who is transmitting (true/false)
      # Displays transmitter's name during radio communications
      SHOW_TRANSMITTER_NAME: "true"
      
      # Number of days to keep transmission logs (number)
      # Older logs are automatically deleted after this many days
      TRANSMISSION_LOG_RETENTION: "2"
      
      # Maximum number of retransmission nodes (0 = unlimited)
      # Limits how many relay stations can chain together
      RETRANSMISSION_NODE_LIMIT: "0"

      # ===== SERVER CONNECTION SETTINGS =====
      
      # File path for exporting connected clients list
      # Only change if you need the file in a different location
      CLIENT_EXPORT_FILE_PATH: "clients-list.json"
      
      # IP address the server listens on (0.0.0.0 = all interfaces)
      # Change only if you need to bind to a specific network interface
      SERVER_IP: "0.0.0.0"
      
      # Port number the server listens on
      # Must match the port mapping above (default: 5002)
      SERVER_PORT: "5002"
      
      # Automatically configure router port forwarding via UPnP (true/false)
      # Set to "true" if your router supports UPnP and you want automatic setup
      UPNP_ENABLED: "true"
      
      # Check for beta version updates (true/false)
      # Set to "true" if you want to be notified about beta releases
      CHECK_FOR_BETA_UPDATES: "false"

      # ===== EXTERNAL AWACS MODE PASSWORDS =====
      # These passwords allow external applications to control radios
      # Change these from default values for security!
      
      # Password for blue team external control
      # Change "blue" to a secure password for blue team access
      EXTERNAL_AWACS_MODE_BLUE_PASSWORD: "blue"
      
      # Password for red team external control  
      # Change "red" to a secure password for red team access
      EXTERNAL_AWACS_MODE_RED_PASSWORD: "red"
```

**Important Note about Configuration**: The server generates its configuration file (`cfg/server.cfg`) automatically on startup based on your environment variables using the entrypoint script. The configuration is created fresh each time the container starts, ensuring your environment variable changes are always applied.

**Volume Mounts**: Only the `Presets/` directory is mounted as a volume to allow easy management of server-side presets. All other configuration files (cfg/server.cfg, logs, client exports, etc.) are stored within the container and managed automatically.

To modify the configuration:

1. Stop the container: `docker-compose down`
2. Edit the environment variables in your `docker-compose.yml` file
3. Restart the container: `docker-compose up -d`

The entrypoint script will regenerate the configuration file with your updated settings on startup.

## Server Features

### Enhanced Server Management

Version 2.2.0.4 introduces several new server management features:

- **Improved IP Detection**: Automatic server IP detection for SRS connections
- **Simplified Chat Commands**: New shorter autoconnect chat command (just port needed)
- **Enhanced UI**: Consistent buttons and interface improvements across settings
- **Better Logging**: Fixed transmission logging with proper CSV format support
- **Server-Side Presets Fix**: Automatic command-line argument handling for server-side presets feature

### File Structure

The server automatically creates and manages all necessary files within the container:
- **cfg/server.cfg**: Generated automatically from environment variables on each startup
- **Presets/**: Mounted volume for server-side preset management (optional)
- **Logs and exports**: Stored within the container filesystem
- **banned.txt**: Managed internally by the server for IP banning

## REST API

The server now includes an optional REST API for remote management. Enable it by setting `HTTP_SERVER_ENABLED: "true"` in your configuration.

**⚠️ SECURITY WARNING**: The REST API provides administrative control over your server including the ability to kick and ban clients. Do NOT expose port 8080 to the public internet. Only expose this port on internal networks or use proper authentication/firewall rules. Exposing this API publicly could allow unauthorized users to take control of your server.

### API Security Best Practices

- **Internal Use Only**: Only bind the API to internal/private networks
- **Firewall Protection**: Use firewall rules to restrict API access to trusted IPs
- **VPN Access**: Consider requiring VPN access for API management
- **Monitor Usage**: Keep logs of API access and watch for unauthorized attempts

### Available Endpoints

#### Get Connected Clients
```http
GET /clients
```
Returns a list of all currently connected clients with their information.

#### Kick Client by GUID
```http
POST /client/kick/guid/{client_guid}
```
Disconnects a client using their unique GUID.

#### Kick Client by Name
```http
POST /client/kick/name/{client_name}
```
Disconnects a client using their display name.

#### Ban Client by GUID
```http
POST /client/ban/guid/{client_guid}
```
Bans a client by their GUID and adds their IP to the banned list.

#### Ban Client by Name
```http
POST /client/ban/name/{client_name}
```
Bans a client by their name and adds their IP to the banned list.

### API Usage Examples

```bash
# Get all connected clients
curl http://your-server:8080/clients

# Kick a client by name
curl -X POST http://your-server:8080/client/kick/name/PlayerName

# Ban a client by GUID
curl -X POST http://your-server:8080/client/ban/guid/12345678-1234-1234-1234-123456789abc
```

## Channel Presets

Server-side channel presets allow you to provide predefined radio configurations to all clients. This feature is particularly useful for organized events or training scenarios.

**Important**: The SRS server requires the `--serverPresetChannelsEnabled=true` command-line argument to activate server-side presets, regardless of the configuration file setting. This Docker image automatically handles this requirement - when you set `SERVER_PRESETS_ENABLED: "true"`, the entrypoint script will automatically add the necessary command-line argument during server startup.

### Setting Up Presets

1. **Enable the Feature**
   ```yaml
   SERVER_PRESETS_ENABLED: "true"
   ```
   
   The entrypoint script will automatically add `--serverPresetChannelsEnabled=true` to the server startup command when this is enabled.

2. **Create Preset Files**
   Create `.txt` files in the mounted `Presets/` directory (default: `/docker/dcs-srs/Presets/` on the host).

3. **Preset File Format**
   ```json
   {
     "name": "Training Frequencies",
     "channels": [
       {
         "name": "Tower",
         "frequency": 251.0,
         "modulation": "AM"
       },
       {
         "name": "Ground",
         "frequency": 249.5,
         "modulation": "FM"
       }
     ]
   }
   ```

### Preset Naming

- Preset names ignore spaces, casing, and special characters for matching
- Files should be named descriptively (e.g., `training-presets.json`)
- Clients will see these presets in their SRS radio interface

### Managing Presets

To update presets:
1. Edit files in the host directory: `/docker/dcs-srs/Presets/`
2. Changes are automatically picked up by the server
3. No container restart required for preset changes

**Note**: If server-side presets aren't working, ensure `SERVER_PRESETS_ENABLED` is set to `"true"` (as a string) in your docker-compose.yml or .env file. The containerized solution automatically handles the required command-line argument that the SRS server needs to enable this feature.

## IP Banning

The server automatically manages banned IPs using a `banned.txt` file stored within the container. IPs can be banned using the REST API endpoints.

### Manual IP Management

Since the banned.txt file is stored within the container, manual IP management requires accessing the container:

```bash
# Access the container to view banned IPs
docker exec -it dcs-srs cat /app/banned.txt

# Remove a banned IP by recreating the container
# (This will clear all bans - use REST API for selective management)
docker-compose restart
```

## Troubleshooting

### Common Issues

1. **Port conflicts**
   ```bash
   # Check if port 5002 is in use (both TCP and UDP)
   netstat -tulpn | grep :5002
   
   # Change port in .env file
   SRS_PORT=5004
   ```

2. **Container won't start**
   ```bash
   # Check container logs
   docker-compose logs dcs-srs-server
   
   # Restart the service
   docker-compose restart
   ```

3. **DCS Client Connection Issues**
   ```bash
   # Verify both TCP and UDP ports are exposed
   docker port dcs-srs-server
   
   # Should show:
   # 5002/tcp -> 0.0.0.0:5002
   # 5002/udp -> 0.0.0.0:5002
   ```

### Monitoring

```bash
# View real-time logs
docker-compose logs -f

# Monitor container resources
docker stats dcs-srs-server

# Check container health
docker-compose ps
```

### Network Requirements

- **Port 5002 TCP**: Required for client synchronization and server communication
- **Port 5002 UDP**: Required for voice data transmission  
- **Port 8080 TCP**: Required for REST API (if enabled) - ⚠️ **DO NOT expose to internet**
- **Firewall**: Ensure both TCP and UDP traffic is allowed on port 5002
- **Important**: The server opens ONE PORT using both TCP AND UDP protocols - both must be forwarded

### Server Hosting Notes

For server hosting:
- **Always open both TCP AND UDP on port 5002** (or your configured port)
- **REST API Security**: If using the REST API, only expose port 8080 to trusted networks
- Use manual port forwarding - UPnP may not work reliably for both protocols
- If clients can connect but can't use PTT (Push-to-Talk), check UDP port forwarding
- The VoIP Green Plug indicator shows if voice communication is working properly

### DCS Integration

### Client Setup

1. **Install DCS-SRS Client**: Download from the official DCS-SRS repository
2. **Configure Connection**: 
   - Server IP: Your server's IP address
   - Port: 5002 (or your configured port)
   - Password: If you set one in your .env file
3. **Test Connection**: Join your server and test voice communication

### Server Information for Clients

Share these details with your pilots:
- **Server Address**: `your-server-ip:5002`
- **Password**: (if configured)
- **Server Name**: (as set in SRS_SERVER_NAME)

## Support

### Docker Hub

Find the latest images at: [Docker Hub - jaycadi/dcs-srs-server](https://hub.docker.com/r/jaycadi/dcs-srs-server)

### DCS-SRS Resources

- [DCS-SRS Official Website](http://dcssimpleradio.com/)
- [DCS-SRS Binary Downloads](https://github.com/ciribob/DCS-SimpleRadioStandalone/releases)
- [DCS-SRS Official Documentation](https://github.com/ciribob/DCS-SimpleRadioStandalone)
- [DCS World Forums](https://forums.eagle.ru/)

### Getting Help

- Create an issue in this repository for container-specific problems
- Check DCS-SRS documentation for client setup and radio configuration
- Visit DCS community forums for general DCS-SRS support
- Download the latest DCS-SRS client from the [official releases page](https://github.com/ciribob/DCS-SimpleRadioStandalone/releases)

## Acknowledgments

Special thanks to **Atlas Defense Industries** ([https://adi.sc/](https://adi.sc/)) for their invaluable assistance in developing, testing, and validating this Docker containerization setup. ADI is the largest exclusive organization in Star Citizen and has extensively tested this DCS-SRS Docker implementation with over 90 concurrent users, ensuring it can handle large-scale operations. Their expertise in large-scale gaming operations and server deployment has made this project possible and battle-tested for real-world use.

---

**Important**: Version 2.2.0.4 requires both TCP and UDP on the same port (default 5002). The server will NOT work properly if only one protocol is forwarded. Ensure your firewall and network configuration allow both protocols.

**Note**: This Docker image is designed to simplify DCS-SRS server deployment for communities and groups. For the latest DCS-SRS client software, visit [http://dcssimpleradio.com/](http://dcssimpleradio.com/) or download directly from the [GitHub releases page](https://github.com/ciribob/DCS-SimpleRadioStandalone/releases).
