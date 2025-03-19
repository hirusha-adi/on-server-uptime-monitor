#!/bin/bash

# Path to config file
CONFIG_FILE="/srv/on-server-uptime-monitor/config.json"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    exit 1
fi

# Process services
jq -c '.services[]' "$CONFIG_FILE" | while read -r service; do
    NAME=$(echo "$service" | jq -r '.name')
    URL=$(echo "$service" | jq -r '.url')
    DIR=$(echo "$service" | jq -r '.run_command.in_dir')
    COMMAND=$(echo "$service" | jq -r '.run_command.command')

    # Send request with curl
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL")

    # Restart if down
    if [[ "$HTTP_STATUS" =~ ^(502|500|503|504)$ ]]; then
        cd "$DIR" && eval "$COMMAND"
    fi
done
