#!/bin/bash

# Define script directory
SCRIPT_DIR="/srv/on-server-uptime-monitor"
LOG_FILE="$SCRIPT_DIR/monitor_output.log"

# Change to script directory
cd "$SCRIPT_DIR" || { echo "❌ Failed to change directory!"; exit 1; }

# Make sure script is executable
chmod +x monitor.sh

# Run the script in the background
echo "🚀 Starting service monitor..."
nohup "$SCRIPT_DIR/monitor.sh" > "$LOG_FILE" 2>&1 &

echo "✅ Service monitor started!"
