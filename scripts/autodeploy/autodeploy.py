import os
import subprocess
import yaml

# Path to the Docker Compose file two levels up
COMPOSE_FILE = os.path.join(os.path.dirname(__file__), "../../docker-compose.yml")

def run_command(command, cwd=None):
    """Runs a shell command and returns the output."""
    result = subprocess.run(command, shell=True, cwd=cwd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error running command '{command}': {result.stderr}")
    return result.stdout.strip()

def update_local_service(app_dir, service_name):
    """Pulls latest changes from a Git repository and rebuilds the Docker service."""
    print(f"Checking for updates in local service: {service_name}...")

    # Fetch latest changes
    run_command("git fetch", cwd=app_dir)

    # Check for new commits
    local_commit = run_command("git rev-parse HEAD", cwd=app_dir)
    remote_commit = run_command("git rev-parse origin/main", cwd=app_dir)

    if local_commit != remote_commit:
        print(f"Changes detected in {service_name}. Pulling latest changes and rebuilding...")
        run_command("git pull", cwd=app_dir)
        run_command(f"docker compose -f {COMPOSE_FILE} up -d --build {service_name}")
    else:
        print(f"No changes in {service_name}.")

def update_image_service(service_name, image_name):
    """Pulls the latest Docker image and restarts the service."""
    print(f"Checking for updates in image-based service: {service_name}...")
    run_command(f"docker pull {image_name}")
    run_command(f"docker compose -f {COMPOSE_FILE} up -d {service_name}")

def main():
    # Load the Docker Compose configuration
    with open(COMPOSE_FILE, "r") as file:
        compose_data = yaml.safe_load(file)

    # Iterate through services in the Docker Compose file
    for service_name, service_config in compose_data.get("services", {}).items():
        build_context = service_config.get("build", {}).get("context")
        image = service_config.get("image")

        if build_context:
            # Resolve path relative to COMPOSE_FILE's directory
            build_context = os.path.abspath(os.path.join(os.path.dirname(COMPOSE_FILE), build_context))
            # Update local service if it's built from a local context
            update_local_service(build_context, service_name)
        elif image:
            # Update image-based service
            update_image_service(service_name, image)
        else:
            print(f"No build context or image found for {service_name}. Skipping...")

if __name__ == "__main__":
    main()