# Requirements

- Docker
- Docker Compose
- Python 3.x

# Setup

- Pull the repositories you'd like to run
- Add these services to `docker-compose.yml`
- Create `.env` based on `.env.example`
- `./scripts/generate_conf.sh` to generate the nginx conf.

# For HTTPS (optional)

- Install certbot
- `sudo ./scripts/setup_ssl.sh`

# Run

`docker compose up -d`

# Autodeploy (optional, untested)

`crontab -e`

Then add the following line to run the script every minute:

`* * * * * ./scripts/poll_and_deploy.sh >> ./scripts/poll_and_deploy.log 2>&1`