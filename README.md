# Requirements

- Docker
- Docker Compose
- Python 3.x

# Setup

- Pull the repositories you'd like to run
- Add these services to `docker-compose.yml`
- Create `.env` based on `.env.example`
- `./scripts/generate_conf.sh` to generate the nginx conf.

# For HTTPS:

- Install certbot
- `sudo ./scripts/setup_ssl.sh`

# Run

`docker compose up -d`