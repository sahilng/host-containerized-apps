#!/bin/bash

# Check if venv exists; if not, create it and install dependencies
if [ ! -d "./scripts/generate_conf_py/venv" ]; then
    echo "Virtual environment not found. Creating it..."
    python3 -m venv ./scripts/generate_conf_py/venv
fi

echo "Installing dependencies..."
./scripts/generate_conf_py/venv/bin/python -m pip install -r ./scripts/generate_conf_py/requirements.txt

# Run the Python script using the virtual environment's Python interpreter
./scripts/generate_conf_py/venv/bin/python ./scripts/generate_conf_py/generate_conf.py