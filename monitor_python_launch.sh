#!/bin/bash

# crontab -e
# */5 * * * * /srv/on-server-uptime-monitor/monitor_python_launch.sh

# Define paths
SCRIPT_DIR="/srv/on-server-uptime-monitor"
VENV_DIR="$SCRIPT_DIR/venv"
LOG_FILE="$SCRIPT_DIR/monitor_output.log"
PYTHON="$VENV_DIR/bin/python3"

# Change to script directory
cd "$SCRIPT_DIR" || { echo "❌ Failed to change directory!"; exit 1; }

# Ensure Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 not found! Install it first."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "🚀 Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Install dependencies if needed
if [ ! -f "$VENV_DIR/installed.txt" ]; then
    echo "📦 Installing dependencies..."
    pip install requests
    touch "$VENV_DIR/installed.txt"  # Mark dependencies as installed
fi

# Run the script in the background
echo "🚀 Starting service monitor..."
nohup "$PYTHON" "$SCRIPT_DIR/monitor_python.py" > "$LOG_FILE" 2>&1 &

echo "✅ Service monitor started!"
