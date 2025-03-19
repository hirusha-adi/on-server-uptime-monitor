#!/bin/bash

# crontab -e
# */5 * * * * /srv/on-server-uptime-monitor/monitor_bash_launch.sh

# Define script directory
SCRIPT_DIR="/srv/on-server-uptime-monitor"

# Change to script directory
cd "$SCRIPT_DIR" || exit 1

# Make sure script is executable
chmod +x monitor_services.sh

# Run script silently
nohup "$SCRIPT_DIR/monitor_services.sh" >/dev/null 2>&1 &
