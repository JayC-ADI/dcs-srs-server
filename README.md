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
# filepath: d:\Coding\ADI\new\dcs-srs-server\docker-compose.yml
# Docker Compose configuration for DCS-SRS (Digital Combat Simulator - Simple Radio Standalone) server
# This file defines how to run the SRS server in a Docker container
version: '3.8'

services:
  dcs-srs:
    # Container name - change this if you want a different name for your container
    container_name: dcs-srs
    
    # Docker image to use - only change if you need a different version
    image: jaycadi/dcs-srs-server:2.2.0.3-beta
    
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
    
    environment:
      # ===== GENERAL RADIO SETTINGS =====
      
      # Log all radio transmissions to file (true/false)
      # Set to "true" if you want to record all voice communications
      TRANSMISSION_LOG_ENABLED: "false"
      
      # Export connected clients list to JSON file (true/false)
      # Useful for external applications that need to know who's connected
      CLIENT_EXPORT_ENABLED: "false"
      
      # Export data for LotATC (Situational Awareness tool) (true/false)
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

### Environment Variables Reference

All configuration options are documented directly in the docker-compose.yml file with comments explaining each setting. Simply modify the values in the docker-compose.yml file and restart the service:

```bash
docker-compose down
docker-compose up -d
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
- **Firewall**: Ensure both TCP and UDP traffic is allowed on port 5002

## DCS Integration

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

**Important**: DCS-SRS requires both TCP and UDP on port 5002. Ensure your firewall and network configuration allow both protocols.

**Note**: This Docker image is designed to simplify DCS-SRS server deployment for communities and groups. For the latest DCS-SRS client software, visit [http://dcssimpleradio.com/](http://dcssimpleradio.com/) or download directly from the [GitHub releases page](https://github.com/ciribob/DCS-SimpleRadioStandalone/releases).
