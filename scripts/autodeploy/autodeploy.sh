#!/bin/bash

# Check if venv exists; if not, create it and install dependencies
if [ ! -d "./scripts/autodeploy/venv" ]; then
    echo "Virtual environment not found. Creating it..."
    python3 -m venv ./scripts/autodeploy/venv
fi

echo "Installing dependencies..."
./scripts/generate_conf_py/venv/bin/python -m pip install -r ./scripts/autodeploy/requirements.txt

# Run the Python script using the virtual environment's Python interpreter
./scripts/autodeploy/venv/bin/python ./scripts/autodeploy/autodeploy.py