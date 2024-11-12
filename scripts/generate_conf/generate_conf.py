import os
import yaml
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def generate_nginx_conf(env, domain, compose_file="docker-compose.yml"):
    output_file = f"./nginx/conf/{env}.conf"

    # Load Docker Compose file
    with open(compose_file, 'r') as f:
        compose_data = yaml.safe_load(f)

    # Extract services, including only those with an exposed port, and excluding Nginx
    apps = {
        name: service.get('expose', [None])[0]
        for name, service in compose_data.get('services', {}).items()
        if name != 'nginx' and service.get('expose')
    }

    # Start building the Nginx config
    if env == "https":
        conf = f"""server {{
    listen 80;
    server_name {domain};

    # Redirect all HTTP requests to HTTPS
    location / {{
        return 301 https://$host$request_uri;
    }}
}}

server {{
    listen 443 ssl;
    server_name {domain};

    ssl_certificate /etc/letsencrypt/live/{domain}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/{domain}/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Serve the static site at root
    location / {{
        root /var/www/html;
        index index.html;
        try_files $uri $uri/ =404;
    }}
    """
    else:
        conf = f"""server {{
    listen 80;

    # Serve the static site at root
    location / {{
        root /var/www/html;
        index index.html;
        try_files $uri $uri/ =404;
    }}
    """

    # Add proxy configuration for each app with an exposed port
    for app_name, port in apps.items():
        # Initialize the location block lines
        location_lines = [
            f"    # Proxy /{app_name} to {app_name}",
            f"    location /{app_name}/ {{"
        ]

        # Check if htpasswd file exists for this app
        htpasswd_file = f"./nginx/basic-auth/{app_name}.htpasswd"
        if os.path.exists(htpasswd_file):
            # Add basic auth directives
            location_lines.append(f"        auth_basic \"Restricted Area\";")
            location_lines.append(f"        auth_basic_user_file /etc/nginx/basic-auth/{app_name}.htpasswd;")

        # Add the rest of the location block
        location_lines.extend([
            f"        rewrite ^/{app_name}/(.*)$ /$1 break;",  # Strip /{app_name} prefix
            f"        proxy_pass http://{app_name}:{port};",
            f"        proxy_set_header Host $host;",
            f"        proxy_set_header X-Real-IP $remote_addr;",
            f"        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;",
            f"        proxy_set_header X-Forwarded-Proto $scheme;",
            f"    }}\n"
        ])

        # Add the location block to the config
        conf += "\n" + "\n".join(location_lines)

    # Close the server block
    conf += "\n}"

    # Write the configuration to a file
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, 'w') as f:
        f.write(conf)

    print(f"Nginx configuration generated at {output_file}")

# Define environment variables from the .env file
ENVIRONMENT = os.getenv("ENVIRONMENT")
DOMAIN = os.getenv("DOMAIN")

if not ENVIRONMENT or not DOMAIN:
    print("Error: ENVIRONMENT and DOMAIN environment variables must be set in the .env file.")
else:
    generate_nginx_conf(ENVIRONMENT, DOMAIN)
