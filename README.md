# Setup

Install Docker and Docker Compose

# For HTTPS:

- Install certbot
- Create `.env` based on `.env.example`
- `sudo ./scripts/setup_ssl.sh`

# Run

`docker compose up -d`

# Autodeploy

`crontab -e`

Then add the following line to run the script every minute:

`* * * * * ./scripts/poll_and_deploy.sh >> ./scripts/poll_and_deploy.log 2>&1`