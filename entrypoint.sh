#!/bin/bash
# SRS Server Configuration and Startup Script

set -e
CONFIG_FILE="server.cfg"

# ============================================================================
# CREATE REQUIRED DIRECTORIES
# ============================================================================
echo "Creating required SRS server directories..."
mkdir -p Presets
chmod 755 Presets
echo "Created directories: Presets"
echo ""

# ============================================================================
# GENERATE CONFIGURATION FILE
# ============================================================================
echo "Generating SRS server configuration..."

# Remove existing configuration file if it exists
if [ -f "$CONFIG_FILE" ]; then
    echo "Removing existing $CONFIG_FILE..."
    rm "$CONFIG_FILE"
fi

# [General Settings]
{
echo "[General Settings]"
echo "TRANSMISSION_LOG_ENABLED=${TRANSMISSION_LOG_ENABLED:-false}"
echo "CLIENT_EXPORT_ENABLED=${CLIENT_EXPORT_ENABLED:-false}"
echo "SERVER_SIDE_PRESETS_ENABLED=${SERVER_SIDE_PRESETS_ENABLED:-false}"
echo "LOTATC_EXPORT_ENABLED=${LOTATC_EXPORT_ENABLED:-false}"
echo "TEST_FREQUENCIES=${TEST_FREQUENCIES:-247.2,120.3}"
echo "GLOBAL_LOBBY_FREQUENCIES=${GLOBAL_LOBBY_FREQUENCIES:-248.22}"
echo "EXTERNAL_AWACS_MODE=${EXTERNAL_AWACS_MODE:-true}"
echo "COALITION_AUDIO_SECURITY=${COALITION_AUDIO_SECURITY:-false}"
echo "SPECTATORS_AUDIO_DISABLED=${SPECTATORS_AUDIO_DISABLED:-false}"
echo "LOS_ENABLED=${LOS_ENABLED:-false}"
echo "DISTANCE_ENABLED=${DISTANCE_ENABLED:-false}"
echo "IRL_RADIO_TX=${IRL_RADIO_TX:-false}"
echo "IRL_RADIO_RX_INTERFERENCE=${IRL_RADIO_RX_INTERFERENCE:-false}"
echo "RADIO_EXPANSION=${RADIO_EXPANSION:-true}"
echo "ALLOW_RADIO_ENCRYPTION=${ALLOW_RADIO_ENCRYPTION:-true}"
echo "STRICT_RADIO_ENCRYPTION=${STRICT_RADIO_ENCRYPTION:-false}"
echo "SHOW_TUNED_COUNT=${SHOW_TUNED_COUNT:-true}"
echo "RADIO_EFFECT_OVERRIDE=${RADIO_EFFECT_OVERRIDE:-false}"
echo "SHOW_TRANSMITTER_NAME=${SHOW_TRANSMITTER_NAME:-true}"
echo "TRANSMISSION_LOG_RETENTION=${TRANSMISSION_LOG_RETENTION:-2}"
echo "RETRANSMISSION_NODE_LIMIT=${RETRANSMISSION_NODE_LIMIT:-0}"
echo ""

# [Server Settings]
echo "[Server Settings]"
echo "CLIENT_EXPORT_FILE_PATH=${CLIENT_EXPORT_FILE_PATH:-clients-list.json}"
echo "SERVER_IP=${SERVER_IP:-0.0.0.0}"
echo "SERVER_PORT=${SERVER_PORT:-5002}"
echo "UPNP_ENABLED=${UPNP_ENABLED:-true}"
echo "CHECK_FOR_BETA_UPDATES=${CHECK_FOR_BETA_UPDATES:-false}"
echo "HTTP_SERVER_ENABLED=${HTTP_SERVER_ENABLED:-false}"
echo "HTTP_SERVER_PORT=${HTTP_SERVER_PORT:-8080}"
echo ""

# [External AWACS Mode Settings]
echo "[External AWACS Mode Settings]"
echo "EXTERNAL_AWACS_MODE_BLUE_PASSWORD=${EXTERNAL_AWACS_MODE_BLUE_PASSWORD:-blue}"
echo "EXTERNAL_AWACS_MODE_RED_PASSWORD=${EXTERNAL_AWACS_MODE_RED_PASSWORD:-red}"
} > "$CONFIG_FILE"

# ============================================================================
# DISPLAY CONFIGURATION STATUS
# ============================================================================
echo ""
echo "Current server.cfg:"
echo "==================="
cat "$CONFIG_FILE"
echo "==================="
echo ""

# ============================================================================
# START THE SRS SERVER
# ============================================================================
echo "Starting SRS Server..."
exec ./SRS-Server-Commandline --cfg=server.cfg