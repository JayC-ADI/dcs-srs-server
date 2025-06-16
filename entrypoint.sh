#!/bin/bash
# SRS Server Configuration and Startup Script

set -e
CONFIG_FILE="server.cfg"

# ============================================================================
# CREATE REQUIRED DIRECTORIES
# ============================================================================
echo "Creating required SRS server directories..."
mkdir -p data exports logs Presets
chmod 755 data exports logs Presets
echo "Created directories: data, exports, logs, Presets"
echo ""

# ============================================================================
# GENERATE CONFIGURATION FILE
# ============================================================================
echo "Generating SRS server configuration..."

# Remove existing configuration file to ensure clean generation
if [ -f "$CONFIG_FILE" ]; then
    echo "Removing existing $CONFIG_FILE..."
    rm -f "$CONFIG_FILE"
fi

# [General Settings]
echo "[General Settings]" > "$CONFIG_FILE"
echo "TRANSMISSION_LOG_ENABLED=${TRANSMISSION_LOG_ENABLED:-false}" >> "$CONFIG_FILE"
echo "CLIENT_EXPORT_ENABLED=${CLIENT_EXPORT_ENABLED:-false}" >> "$CONFIG_FILE"
echo "SERVER_SIDE_PRESETS_ENABLED=${SERVER_SIDE_PRESETS_ENABLED:-false}" >> "$CONFIG_FILE"
echo "LOTATC_EXPORT_ENABLED=${LOTATC_EXPORT_ENABLED:-false}" >> "$CONFIG_FILE"
echo "TEST_FREQUENCIES=${TEST_FREQUENCIES:-247.2,120.3}" >> "$CONFIG_FILE"
echo "GLOBAL_LOBBY_FREQUENCIES=${GLOBAL_LOBBY_FREQUENCIES:-248.22}" >> "$CONFIG_FILE"
echo "EXTERNAL_AWACS_MODE=${EXTERNAL_AWACS_MODE:-true}" >> "$CONFIG_FILE"
echo "COALITION_AUDIO_SECURITY=${COALITION_AUDIO_SECURITY:-false}" >> "$CONFIG_FILE"
echo "SPECTATORS_AUDIO_DISABLED=${SPECTATORS_AUDIO_DISABLED:-false}" >> "$CONFIG_FILE"
echo "LOS_ENABLED=${LOS_ENABLED:-false}" >> "$CONFIG_FILE"
echo "DISTANCE_ENABLED=${DISTANCE_ENABLED:-false}" >> "$CONFIG_FILE"
echo "IRL_RADIO_TX=${IRL_RADIO_TX:-false}" >> "$CONFIG_FILE"
echo "IRL_RADIO_RX_INTERFERENCE=${IRL_RADIO_RX_INTERFERENCE:-false}" >> "$CONFIG_FILE"
echo "RADIO_EXPANSION=${RADIO_EXPANSION:-true}" >> "$CONFIG_FILE"
echo "ALLOW_RADIO_ENCRYPTION=${ALLOW_RADIO_ENCRYPTION:-true}" >> "$CONFIG_FILE"
echo "STRICT_RADIO_ENCRYPTION=${STRICT_RADIO_ENCRYPTION:-false}" >> "$CONFIG_FILE"
echo "SHOW_TUNED_COUNT=${SHOW_TUNED_COUNT:-true}" >> "$CONFIG_FILE"
echo "RADIO_EFFECT_OVERRIDE=${RADIO_EFFECT_OVERRIDE:-false}" >> "$CONFIG_FILE"
echo "SHOW_TRANSMITTER_NAME=${SHOW_TRANSMITTER_NAME:-true}" >> "$CONFIG_FILE"
echo "TRANSMISSION_LOG_RETENTION=${TRANSMISSION_LOG_RETENTION:-2}" >> "$CONFIG_FILE"
echo "RETRANSMISSION_NODE_LIMIT=${RETRANSMISSION_NODE_LIMIT:-0}" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"

# [Server Settings]
echo "[Server Settings]" >> "$CONFIG_FILE"
echo "CLIENT_EXPORT_FILE_PATH=${CLIENT_EXPORT_FILE_PATH:-clients-list.json}" >> "$CONFIG_FILE"
echo "SERVER_IP=${SERVER_IP:-0.0.0.0}" >> "$CONFIG_FILE"
echo "SERVER_PORT=${SERVER_PORT:-5002}" >> "$CONFIG_FILE"
echo "UPNP_ENABLED=${UPNP_ENABLED:-true}" >> "$CONFIG_FILE"
echo "CHECK_FOR_BETA_UPDATES=${CHECK_FOR_BETA_UPDATES:-false}" >> "$CONFIG_FILE"
echo "HTTP_SERVER_ENABLED=${HTTP_SERVER_ENABLED:-false}" >> "$CONFIG_FILE"
echo "HTTP_SERVER_PORT=${HTTP_SERVER_PORT:-8080}" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"

# [External AWACS Mode Settings]
echo "[External AWACS Mode Settings]" >> "$CONFIG_FILE"
echo "EXTERNAL_AWACS_MODE_BLUE_PASSWORD=${EXTERNAL_AWACS_MODE_BLUE_PASSWORD:-blue}" >> "$CONFIG_FILE"
echo "EXTERNAL_AWACS_MODE_RED_PASSWORD=${EXTERNAL_AWACS_MODE_RED_PASSWORD:-red}" >> "$CONFIG_FILE"

# ============================================================================
# DISPLAY GENERATED CONFIGURATION
# ============================================================================
echo ""
echo "Generated server.cfg:"
echo "====================="
cat "$CONFIG_FILE"
echo "====================="
echo ""

# ============================================================================
# START THE SRS SERVER
# ============================================================================
echo "Starting SRS Server..."
exec ./SRS-Server-Commandline --cfg=server.cfg