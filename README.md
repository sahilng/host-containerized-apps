# Requirements

- Docker
- Docker Compose
- Python 3.x

# Setup

- Remove the example app directories `app1` and `app2` as well as the corresponding services from `docker-compose.yml`
- Pull the repositories you'd like to run
- Add these services to `docker-compose.yml`
- Create `.env` based on `.env.example`
- Generate the Nginx conf: 
```sh
./scripts/generate_conf.sh
``` 

# If using HTTPS

- Install certbot
- Setup SSL:
```sh
sudo ./scripts/setup_ssl.sh
```

# Run

```sh
docker compose up -d
```

# Autodeploy (optional, untested)

```sh
crontab -e
```

Then add the following line to run the script every minute:

```sh
* * * * * ./scripts/poll_and_deploy.sh >> ./scripts/poll_and_deploy.log 2>&1
```