#!/bin/bash

# Configuration file path
CONFIG_FILE="/srv/on-server-uptime-monitor/config.json"
LOG_FILE="/srv/on-server-uptime-monitor/monitor.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    log_message "❌ jq is not installed! Install it using: sudo apt install jq"
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    log_message "❌ Config file not found: $CONFIG_FILE"
    exit 1
fi

# Read and process services from config.json
jq -c '.services[]' "$CONFIG_FILE" | while read -r service; do
    NAME=$(echo "$service" | jq -r '.name')
    URL=$(echo "$service" | jq -r '.url')
    DIR=$(echo "$service" | jq -r '.run_command.in_dir')
    COMMAND=$(echo "$service" | jq -r '.run_command.command')

    log_message "🔍 Checking $NAME at $URL..."

    # Send request with curl
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL")

    # Restart on Caddy-related error codes
    if [[ "$HTTP_STATUS" =~ ^(500|502|503|504|521|522|523|308)$ ]]; then
        log_message "⚠️ $NAME is down (Status: $HTTP_STATUS). Restarting..."

        # Restart service
        if cd "$DIR"; then
            if eval "$COMMAND"; then
                log_message "✅ Successfully restarted $NAME"
            else
                log_message "❌ Failed to restart $NAME"
            fi
        else
            log_message "❌ Failed to access directory: $DIR"
        fi
    else
        log_message "✅ $NAME is up (Status: $HTTP_STATUS)"
    fi
done
