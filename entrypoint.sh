#!/bin/bash
# SRS Server Configuration and Startup Script
# 
# This script generates a configuration file for the DCS Simple Radio Standalone (SRS) server
# and then starts the server. It reads configuration values from environment variables,
# using sensible defaults if no environment variables are set.
#
# The SRS server enables voice communication for DCS (Digital Combat Simulator) multiplayer sessions.

# Exit immediately if any command fails (good practice for scripts)
set -e

# Define the name of the configuration file that will be created
CONFIG_FILE="server.cfg"

# ============================================================================
# CREATE REQUIRED DIRECTORIES
# ============================================================================
# Create directories that the SRS server expects to exist
echo "Creating required SRS server directories..."

# Create directories if they don't exist
mkdir -p data
mkdir -p exports  
mkdir -p logs
mkdir -p Presets

# Set appropriate permissions (readable/writable by owner, readable by group)
chmod 755 data exports logs Presets

echo "Created directories: data, exports, logs, Presets"
echo ""

# ============================================================================
# GENERATE CONFIGURATION FILE
# ============================================================================
# Create a new configuration file (overwrites any existing file)
# The configuration is divided into several sections

echo "Generating SRS server configuration..."

# Start with the General Settings section
echo "[General Settings]" > "$CONFIG_FILE"

# Logging and Export Settings
# These control what information the server records and shares
echo "TRANSMISSION_LOG_ENABLED=${TRANSMISSION_LOG_ENABLED:-false}" >> "$CONFIG_FILE"  # Log radio transmissions
echo "CLIENT_EXPORT_ENABLED=${CLIENT_EXPORT_ENABLED:-false}" >> "$CONFIG_FILE"        # Export client list to file
echo "SERVER_SIDE_PRESETS_ENABLED=${SERVER_SIDE_PRESETS_ENABLED:-false}" >> "$CONFIG_FILE" # Enable server-side channel presets
echo "REST_API_ENABLED=${REST_API_ENABLED:-false}" >> "$CONFIG_FILE"                  # Enable REST API for server management
echo "REST_API_PORT=${REST_API_PORT:-8080}" >> "$CONFIG_FILE"                         # REST API port
echo "LOTATC_EXPORT_ENABLED=${LOTATC_EXPORT_ENABLED:-false}" >> "$CONFIG_FILE"        # Export data for LotATC (air traffic control software)

# Radio Frequency Settings
# These define the default radio channels available to players
echo "TEST_FREQUENCIES=${TEST_FREQUENCIES:-247.2,120.3}" >> "$CONFIG_FILE"            # Frequencies for testing radio setup
echo "GLOBAL_LOBBY_FREQUENCIES=${GLOBAL_LOBBY_FREQUENCIES:-248.22}" >> "$CONFIG_FILE" # Common channel for all players

# AWACS and Security Settings
# AWACS = Airborne Warning and Control System (provides radar coverage)
echo "EXTERNAL_AWACS_MODE=${EXTERNAL_AWACS_MODE:-true}" >> "$CONFIG_FILE"             # Allow external AWACS clients
echo "COALITION_AUDIO_SECURITY=${COALITION_AUDIO_SECURITY:-false}" >> "$CONFIG_FILE" # Separate audio by team/coalition
echo "SPECTATORS_AUDIO_DISABLED=${SPECTATORS_AUDIO_DISABLED:-false}" >> "$CONFIG_FILE" # Block spectators from hearing radio

# Realism Settings
# These add realistic radio limitations (line-of-sight, distance, interference)
echo "LOS_ENABLED=${LOS_ENABLED:-false}" >> "$CONFIG_FILE"                           # Line-of-sight radio limitations
echo "DISTANCE_ENABLED=${DISTANCE_ENABLED:-false}" >> "$CONFIG_FILE"                # Distance-based radio limitations
echo "IRL_RADIO_TX=${IRL_RADIO_TX:-false}" >> "$CONFIG_FILE"                        # Realistic radio transmission effects
echo "IRL_RADIO_RX_INTERFERENCE=${IRL_RADIO_RX_INTERFERENCE:-false}" >> "$CONFIG_FILE" # Realistic radio interference

# Radio Feature Settings
echo "RADIO_EXPANSION=${RADIO_EXPANSION:-true}" >> "$CONFIG_FILE"                    # Enable extended radio features
echo "ALLOW_RADIO_ENCRYPTION=${ALLOW_RADIO_ENCRYPTION:-true}" >> "$CONFIG_FILE"     # Allow encrypted radio channels
echo "STRICT_RADIO_ENCRYPTION=${STRICT_RADIO_ENCRYPTION:-false}" >> "$CONFIG_FILE"  # Enforce encryption rules strictly

# User Interface Settings
echo "SHOW_TUNED_COUNT=${SHOW_TUNED_COUNT:-true}" >> "$CONFIG_FILE"                 # Show how many people are on each frequency
echo "RADIO_EFFECT_OVERRIDE=${RADIO_EFFECT_OVERRIDE:-false}" >> "$CONFIG_FILE"      # Override default radio sound effects
echo "SHOW_TRANSMITTER_NAME=${SHOW_TRANSMITTER_NAME:-true}" >> "$CONFIG_FILE"       # Show who is transmitting

# Maintenance Settings
echo "TRANSMISSION_LOG_RETENTION=${TRANSMISSION_LOG_RETENTION:-2}" >> "$CONFIG_FILE" # Days to keep transmission logs
echo "RETRANSMISSION_NODE_LIMIT=${RETRANSMISSION_NODE_LIMIT:-0}" >> "$CONFIG_FILE"   # Limit radio relay/repeater nodes (0 = no limit)

# Add a blank line for readability in the config file
echo "" >> "$CONFIG_FILE"

# Server Network Settings
echo "[Server Settings]" >> "$CONFIG_FILE"
echo "CLIENT_EXPORT_FILE_PATH=${CLIENT_EXPORT_FILE_PATH:-clients-list.json}" >> "$CONFIG_FILE" # Where to save client list
echo "SERVER_IP=${SERVER_IP:-0.0.0.0}" >> "$CONFIG_FILE"                                       # IP address to bind to (0.0.0.0 = all interfaces)
echo "SERVER_PORT=${SERVER_PORT:-5002}" >> "$CONFIG_FILE"                                      # Network port for client connections
echo "UPNP_ENABLED=${UPNP_ENABLED:-true}" >> "$CONFIG_FILE"                                    # Automatically configure router port forwarding
echo "CHECK_FOR_BETA_UPDATES=${CHECK_FOR_BETA_UPDATES:-false}" >> "$CONFIG_FILE"              # Check for pre-release software updates

# Add another blank line
echo "" >> "$CONFIG_FILE"

# External AWACS Authentication Settings
# These passwords allow external AWACS clients to connect with special privileges
echo "[External AWACS Mode Settings]" >> "$CONFIG_FILE"
echo "EXTERNAL_AWACS_MODE_BLUE_PASSWORD=${EXTERNAL_AWACS_MODE_BLUE_PASSWORD:-blue}" >> "$CONFIG_FILE" # Password for blue team AWACS
echo "EXTERNAL_AWACS_MODE_RED_PASSWORD=${EXTERNAL_AWACS_MODE_RED_PASSWORD:-red}" >> "$CONFIG_FILE"    # Password for red team AWACS

# ============================================================================
# DISPLAY GENERATED CONFIGURATION
# ============================================================================
# Show the user what configuration was generated
echo ""
echo "Generated server.cfg:"
echo "====================="
cat "$CONFIG_FILE"
echo "====================="
echo ""

# ============================================================================
# START THE SRS SERVER
# ============================================================================
# Execute the SRS server binary with the generated configuration
# 'exec' replaces this script process with the server process
echo "Starting SRS Server..."
exec ./SRS-Server-Commandline