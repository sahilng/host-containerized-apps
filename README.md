# Docker Host Setup

Self-host multiple containerized applications using containerized Nginx


## Requirements

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Python 3.x
- A Linux machine capable of running the above


## Setup

- Remove the example app directories `app1` and `app2` as well as the corresponding services from `docker-compose.yml`
- Pull the repositories you'd like to run
- Add these services to `docker-compose.yml`
- Create `.env` based on `.env.example`
- Generate the Nginx conf: 
```sh
./scripts/generate_conf.sh
``` 
- Edit the generated conf to suit your needs - by default there will be a landing page served from `nginx/html` and apps will be served at `/[service name]`


## If using HTTPS

- [Install certbot](https://certbot.eff.org/instructions?ws=nginx&os=snap)
- Setup SSL:
```sh
sudo ./scripts/setup_ssl.sh
```


## Run

```sh
docker compose up -d
```


## Autodeploy (optional, untested)

```sh
crontab -e
```

Then add the following line to run the script every minute:

```sh
* * * * * ./scripts/poll_and_deploy.sh >> ./scripts/poll_and_deploy.log 2>&1
```