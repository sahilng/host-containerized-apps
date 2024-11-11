#!/bin/bash

# Paths to the app repositories and the Docker Compose file
APP1_DIR="app1"  # Replace with the actual path to your app1 repo
APP2_DIR="app2"  # Replace with the actual path to your app2 repo
COMPOSE_FILE="docker-compose.yml"  # Replace with the path to your docker-compose file

# Function to pull changes and restart container if needed
update_service() {
    APP_DIR=$1
    SERVICE_NAME=$2

    # Navigate to the repository directory
    cd $APP_DIR

    # Fetch the latest changes
    git fetch

    # Check if there are new changes
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)  # Adjust branch name if needed

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Changes detected in $SERVICE_NAME. Pulling latest changes and rebuilding..."
        git pull

        # Trigger Docker Compose to rebuild and restart the service
        docker compose -f $COMPOSE_FILE up -d --build $SERVICE_NAME
    else
        echo "No changes in $SERVICE_NAME."
    fi
}

# Update each service
update_service $APP1_DIR $APP1_DIR
update_service $APP2_DIR $APP2_DIR