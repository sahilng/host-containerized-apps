#!/bin/bash

# Check if venv exists; if not, create it and install dependencies
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Creating it..."
    python3 -m venv venv
fi

echo "Installing dependencies..."
venv/bin/python -m pip install -r requirements.txt

# Run the Python script using the virtual environment's Python interpreter
venv/bin/python autodeploy.py