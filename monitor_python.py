import json
import requests
import subprocess
import os
import logging

# Setup logging
LOG_FILE = "service_monitor.log"
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def log_and_print(message, level="info"):
    """Logs and prints messages for better visibility"""
    print(message)
    if level == "error":
        logging.error(message)
    else:
        logging.info(message)

# Load config.json safely
try:
    with open("config.json", "r") as file:
        config = json.load(file)
except Exception as e:
    log_and_print(f"❌ Error loading config.json: {e}", "error")
    exit(1)

# Headers to mimic a real browser
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

for service in config.get("services", []):
    name = service.get("name", "Unknown Service")
    url = service.get("url")
    run_command = service.get("run_command", {})

    if not url or not run_command.get("in_dir") or not run_command.get("command"):
        log_and_print(f"⚠️ Skipping {name} due to missing fields in config.json", "error")
        continue

    try:
        response = requests.get(url, headers=HEADERS, timeout=10)
        status_code = response.status_code
        log_and_print(f"✅ {name}: {status_code}")

        # Restart if bad response, especially 502
        if status_code in [502, 500, 503, 504]:
            log_and_print(f"⚠️ Restarting {name} due to status {status_code}...", "error")

            # Change directory safely
            try:
                os.chdir(run_command["in_dir"])
                subprocess.run(run_command["command"], shell=True, check=True)
                log_and_print(f"✅ Successfully restarted {name}")
            except Exception as cmd_error:
                log_and_print(f"❌ Failed to restart {name}: {cmd_error}", "error")

    except requests.exceptions.RequestException as e:
        log_and_print(f"❌ Error checking {name}: {e}", "error")
