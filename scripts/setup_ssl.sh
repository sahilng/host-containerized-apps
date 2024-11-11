#!/bin/bash

echo "Creating letsencrypt directory..."
mkdir -p $(pwd)/nginx/letsencrypt

echo "Getting letsencrypt files..."
curl -o $(pwd)/nginx/letsencrypt/options-ssl-nginx.conf https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
curl -o $(pwd)/nginx/letsencrypt/ssl-dhparams.pem https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem

echo "Loading environment variables from .env file..."
ENV_FILE=".env"
if [ -f "$ENV_FILE" ]; then
  set -a
  source .env
  set +a
else
  echo ".env file not found. Exiting."
  exit 1
fi

echo "Ensuring DOMAIN and EMAIL are set..."
if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
  echo "DOMAIN or EMAIL not set in .env file. Exiting."
  exit 1
fi

echo "Creating https.conf..."
./scripts/generate_conf.py

echo "Setting webroot and certificate paths..."
WEBROOT_PATH="$(pwd)/nginx/html"  # Path to the webroot folder
CERT_PATH="$(pwd)/nginx/letsencrypt"  # Path to save certificates

echo "Creating the necessary directory for the ACME challenge..."
mkdir -p $WEBROOT_PATH/.well-known/acme-challenge

echo "Starting a temporary HTTP server to serve the ACME challenge"
cd $WEBROOT_PATH
python3 -m http.server 80 &
TEMP_SERVER_PID=$!

echo "Waiting a moment to ensure the server has started..."
sleep 2

echo "Issuing or renewing the certificate..."
certbot certonly --webroot -w $WEBROOT_PATH -d $DOMAIN --email $EMAIL --agree-tos --non-interactive --keep-until-expiring --config-dir $CERT_PATH

echo "Stopping temporary server..."
kill $TEMP_SERVER_PID

echo "Setting permissions for the letsencrypt directory..."
find $CERT_PATH -type d -exec chmod 755 {} \;  # Set directories to 755
find $CERT_PATH -type f -exec chmod 644 {} \;  # Set files to 644

echo "Checking if the certificate was updated and restarting Nginx if necessary..."
if [ $? -eq 0 ]; then
  echo "Certificate obtained or renewed successfully. Restarting Nginx..."
  docker compose restart nginx
else
  echo "Failed to obtain or renew the certificate."
fi