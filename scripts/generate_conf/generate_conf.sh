#!/bin/bash

# Check if venv exists; if not, create it and install dependencies
if [ ! -d "./scripts/generate_conf/venv" ]; then
    echo "Virtual environment not found. Creating it..."
    python3 -m venv ./scripts/generate_conf/venv
fi

echo "Installing dependencies..."
./scripts/generate_conf/venv/bin/python -m pip install -r ./scripts/generate_conf/requirements.txt

# Run the Python script using the virtual environment's Python interpreter
./scripts/generate_conf/venv/bin/python ./scripts/generate_conf/generate_conf.py