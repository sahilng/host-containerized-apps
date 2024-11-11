#!/bin/bash

# Accept the docker path as the first argument and set it in PATH
DOCKER_PATH="$1"
export PATH="$DOCKER_PATH:$PATH"

# Function to print messages with current date and time in Eastern Time as a prefix
log() {
    echo "$(TZ="America/New_York" date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check if venv exists; if not, create it and install dependencies
if [ ! -d "venv" ]; then
    log "Virtual environment not found. Creating it..."
    python3 -m venv venv
fi

log "Installing dependencies..."
venv/bin/python -m pip install -r requirements.txt --quiet --disable-pip-version-check

# Run the Python script using the virtual environment's Python interpreter
log "Running autodeploy.py..."
venv/bin/python autodeploy.py

log "Done!"
echo ""
