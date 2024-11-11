# Host Containerized Apps

Host containerized apps using Docker Compose with Nginx


## Requirements

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/linux/)
- Python 3.x
- A Linux machine capable of running the above (recommended resources: 2 CPU, 4GB RAM)


## Setup

- Remove the example services from `docker-compose.yml`
- Pull app repositories if their images are not available in a registry
- Add these repositories/images as services in `docker-compose.yml`
- Create `.env` based on `.env.example`
- If using HTTPS
    - [Install certbot](https://certbot.eff.org/instructions?ws=nginx&os=snap)
    - Setup SSL:
        ```sh
        sudo ./scripts/setup_ssl.sh
        ```


## Run
- Generate the Nginx conf: 
    ```sh
    ./scripts/generate_conf/generate_conf.sh
    ``` 
- Edit the generated conf in `nginx/conf` to suit your needs - by default there will be a landing page served from `nginx/html` and apps will be served at `/[service name]`
- Start Docker Compose:
    ```sh
    docker compose up -d
    ```


## Autodeploy (optional, untested)

```sh
(crontab -l; echo "* * * * * cd $(pwd)/scripts/autodeploy && ./autodeploy.sh >> autodeploy.log 2>&1 && cd ../../") | crontab -
```