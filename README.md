# Requirements

- Docker
- Docker Compose
- Python 3.x

# Setup

- Remove the example app directories `app1` and `app2` as well as the corresponding services from `docker-compose.yml`
- Pull the repositories you'd like to run
- Add these services to `docker-compose.yml`
- Create `.env` based on `.env.example`
- `./scripts/generate_conf.sh` to generate the nginx conf.

# If using HTTPS

- Install certbot
- `sudo ./scripts/setup_ssl.sh`

# Run

`docker compose up -d`

# Autodeploy (optional, untested)

`crontab -e`

Then add the following line to run the script every minute:

`* * * * * ./scripts/poll_and_deploy.sh >> ./scripts/poll_and_deploy.log 2>&1`