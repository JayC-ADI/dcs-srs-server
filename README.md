# DCS-SRS Voice Server (DCS Simple Radio Standalone)

A high-performance, containerized DCS-SRS voice server implementation designed for Digital Combat Simulator (DCS) radio communications. This project provides a robust, scalable solution for realistic military aviation radio simulation and communication.

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

### Using Docker Compose (Recommended)

1. **Download the docker-compose.yml and .env files**
   ```bash
   wget https://raw.githubusercontent.com/JayC-ADI/dcs-srs-server/main/docker-compose.yml
   wget https://raw.githubusercontent.com/JayC-ADI/dcs-srs-server/main/.env.example -O .env
   ```

2. **Start the service**
   ```bash
   docker-compose up -d
   ```

The service will start automatically using the configuration from your `.env` file.

**Note**: Port 5002 requires both TCP and UDP protocols for proper DCS-SRS communication.

## Configuration

### Environment Variables

Configure your DCS-SRS server using environment variables in the `.env` file:

| Variable | Description | Default |
|----------|-------------|---------|
| `SRS_SERVER_NAME` | Server display name | `DCS SRS Server` |
| `SRS_PASSWORD` | Server password (optional) | `` |
| `SRS_PORT` | Voice communication port | `5002` |
| `SRS_LOG_LEVEL` | Logging level (debug, info, warn, error) | `info` |
| `SRS_MAX_CLIENTS` | Maximum number of clients | `100` |
| `SRS_RADIO_EFFECTS` | Enable radio effects (true/false) | `true` |
| `SRS_COALITION_AUDIO_SECURITY` | Coalition audio security (true/false) | `false` |
| `SRS_SPECTATOR_AUDIO` | Allow spectators to hear audio (true/false) | `true` |
| `SRS_RECORDING_ENABLED` | Enable server-side recording (true/false) | `false` |
| `SRS_RECORDING_QUALITY` | Recording quality (low/medium/high) | `medium` |
| `SRS_AUTO_CONNECT_FREQUENCY` | Auto-connect frequency in MHz | `` |
| `SRS_TEST_FREQUENCIES` | Comma-separated test frequencies | `` |
| `SRS_GLOBAL_LOBBY_FREQUENCIES` | Global lobby frequencies | `` |
| `SRS_DISTANCE_ATTENUATION` | Enable distance-based audio attenuation | `true` |
| `SRS_LOS_ENABLED` | Enable line-of-sight calculations | `false` |
| `SRS_EXTERNAL_AWACS_MODE` | External AWACS mode (true/false) | `false` |
| `SRS_STRICT_RADIO_MODE` | Strict radio mode enforcement | `false` |
| `SRS_VOX_ENABLED` | Voice activation (VOX) enabled | `true` |
| `SRS_CLIENT_EXPORT_ENABLED` | Enable client data export | `false` |
| `SRS_UPNP_ENABLED` | Enable UPnP port forwarding | `false` |
| `SRS_RETRANSMISSION_NODE` | Act as retransmission node | `false` |
| `SRS_ENCRYPTION_ENABLED` | Enable audio encryption | `false` |
| `SRS_ENCRYPTION_KEY` | Encryption key (if encryption enabled) | `` |

### Sample .env File

```env
# Server Configuration
SRS_SERVER_NAME=My Squadron DCS SRS Server
SRS_PASSWORD=
SRS_PORT=5002
SRS_LOG_LEVEL=info
SRS_MAX_CLIENTS=50
SRS_RADIO_EFFECTS=true

# Audio Settings
SRS_COALITION_AUDIO_SECURITY=false
SRS_SPECTATOR_AUDIO=true
SRS_DISTANCE_ATTENUATION=true
SRS_LOS_ENABLED=false
SRS_VOX_ENABLED=true

# Recording Settings
SRS_RECORDING_ENABLED=false
SRS_RECORDING_QUALITY=medium

# Advanced Settings
SRS_EXTERNAL_AWACS_MODE=false
SRS_STRICT_RADIO_MODE=false
SRS_CLIENT_EXPORT_ENABLED=false
SRS_UPNP_ENABLED=false
SRS_RETRANSMISSION_NODE=false

# Security Settings
SRS_ENCRYPTION_ENABLED=false
SRS_ENCRYPTION_KEY=
```

### Docker Compose Configuration

The included `docker-compose.yml` file provides a complete setup:

```yaml
version: '3.8'

services:
  dcs-srs-server:
    image: jaycadi/dcs-srs-server:latest
    container_name: dcs-srs-server
    restart: unless-stopped
    ports:
      - "${SRS_PORT:-5002}:5002/tcp"
      - "${SRS_PORT:-5002}:5002/udp"
    volumes:
      - ./logs:/opt/srs/logs
      - ./config:/opt/srs/config
    environment:
      - SRS_SERVER_NAME=${SRS_SERVER_NAME:-DCS SRS Server}
      - SRS_PASSWORD=${SRS_PASSWORD:-}
      - SRS_PORT=${SRS_PORT:-5002}
      - SRS_LOG_LEVEL=${SRS_LOG_LEVEL:-info}
      - SRS_MAX_CLIENTS=${SRS_MAX_CLIENTS:-100}
      - SRS_RADIO_EFFECTS=${SRS_RADIO_EFFECTS:-true}
      - SRS_COALITION_AUDIO_SECURITY=${SRS_COALITION_AUDIO_SECURITY:-false}
      - SRS_SPECTATOR_AUDIO=${SRS_SPECTATOR_AUDIO:-true}
      - SRS_RECORDING_ENABLED=${SRS_RECORDING_ENABLED:-false}
      - SRS_RECORDING_QUALITY=${SRS_RECORDING_QUALITY:-medium}
      - SRS_AUTO_CONNECT_FREQUENCY=${SRS_AUTO_CONNECT_FREQUENCY:-}
      - SRS_TEST_FREQUENCIES=${SRS_TEST_FREQUENCIES:-}
      - SRS_GLOBAL_LOBBY_FREQUENCIES=${SRS_GLOBAL_LOBBY_FREQUENCIES:-}
      - SRS_DISTANCE_ATTENUATION=${SRS_DISTANCE_ATTENUATION:-true}
      - SRS_LOS_ENABLED=${SRS_LOS_ENABLED:-false}
      - SRS_EXTERNAL_AWACS_MODE=${SRS_EXTERNAL_AWACS_MODE:-false}
      - SRS_STRICT_RADIO_MODE=${SRS_STRICT_RADIO_MODE:-false}
      - SRS_VOX_ENABLED=${SRS_VOX_ENABLED:-true}
      - SRS_CLIENT_EXPORT_ENABLED=${SRS_CLIENT_EXPORT_ENABLED:-false}
      - SRS_UPNP_ENABLED=${SRS_UPNP_ENABLED:-false}
      - SRS_RETRANSMISSION_NODE=${SRS_RETRANSMISSION_NODE:-false}
      - SRS_ENCRYPTION_ENABLED=${SRS_ENCRYPTION_ENABLED:-false}
      - SRS_ENCRYPTION_KEY=${SRS_ENCRYPTION_KEY:-}
    healthcheck:
      test: ["CMD", "netstat", "-tuln", "|", "grep", ":5002"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
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

Find the latest images at: [Docker Hub - jaycadi/dcs-srs-server](https://hub.docker.com/repository/docker/jaycadi/dcs-srs-server/general)

### DCS-SRS Resources

- [DCS-SRS Official Documentation](https://github.com/ciribob/DCS-SimpleRadioStandalone)
- [DCS World Forums](https://forums.eagle.ru/)

### Getting Help

- Create an issue in this repository for container-specific problems
- Check DCS-SRS documentation for client setup and radio configuration
- Visit DCS community forums for general DCS-SRS support

---

**Important**: DCS-SRS requires both TCP and UDP on port 5002. Ensure your firewall and network configuration allow both protocols.
