## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Instructions](#️-instructions)
- [Verification](#installation-verification)
- [Container Management](#container-management)
- [Volume Management](#volume-management)
- [Data](#data)
- [Architecture](#️-architecture)

## Prerequisites

Before starting, make sure you have installed:

- **Docker** (version 20.10 or higher)
  ```bash
  docker --version
  ```
- **Docker Compose** (Docker Compose version v2.24.5)
  ```bash
  docker compose --version
  ```
- **Make** (to use the Makefile)
  ```bash
  make --version
  ```
- **OpenSSL** (to generate secrets)
  ```bash
  openssl version
  ```

## ⚙️ Instructions

### 1. Clone the repository

```bash
git clone <repository-url>
cd inception
```

### 2. Customize the configuration

Edit the `srcs/.env` file with your data:

```bash
# Replace 'gvigano' with your login
DOMAIN_NAME=yours_login.42.fr

WP_ADMIN_USER=yours_login
WP_ADMIN_EMAIL=yours_login@student.42.fr

# Also replace volume paths
WP_DATA_PATH=/home/yours_login/data/wordpress
DB_DATA_PATH=/home/yours_login/data/mariadb
```

```bash
# Replace 'gvigano' with your login in these Makefile commands
setup:
	sudo rm -rf /home/yours_login/data/mariadb
	sudo rm -rf /home/yours_login/data/wordpress
	mkdir -p /home/yours_login/data/mariadb
	mkdir -p /home/yours_login/data/wordpress

	sudo chown -R 999:999 /home/yours_login/data/mariadb
	sudo chown -R 33:33 /home/yours_login/data/wordpress

	sudo chmod 755 /home/yours_login/data/mariadb
	sudo chmod 755 /home/yours_login/data/wordpress

fclean:
	docker-compose --env-file srcs/.env stop
	docker-compose --env-file srcs/.env down -v --rmi all
	sudo rm -rf /home/yours_login/data/mariadb
	sudo rm -rf /home/yours_login/data/wordpress
```

```bash
# Replace the domain name in the setup-ssl.sh file with yours in this code line
-subj "/C=IT/ST=Lazio/L=Roma/O=42/CN=gvigano.42.fr"
```

> ⚠️ **Important**: The only necessary changes are the domain name, admin user/email, and volume paths with your username.

### 3. Configure the hosts file

Add the domain to the `/etc/hosts` file to test locally:

```bash
echo "127.0.0.1 yours_login.42.fr" | sudo tee -a /etc/hosts
```

This command maps the domain `yours_login.42.fr` to the local address `127.0.0.1`, allowing the browser to resolve the domain without public DNS.

### 4. Check secrets

Secrets are automatically managed by the Makefile through the 'setup-secrets.sh' script.
Make sure the script is executable:

```bash
chmod +x setup-secrets.sh
```

### 5. Start the infrastructure

```bash
make up
```

This command:
- Automatically generates secrets if they don't exist
- Creates directories for volumes
- Configures correct permissions
- Starts all containers with Docker Compose

### Other useful Make/docker compose commands

```bash
# Stop containers without removing volumes
make down
# or:
docker compose --env-file srcs/.env down

# Stop containers and remove volumes
make clean
# or:
docker compose --env-file srcs/.env down -v

# Remove everything (containers, volumes, images)
make fclean
# or:
docker compose --env-file srcs/.env stop
docker compose --env-file srcs/.env down -v --rmi all
sudo rm -rf /home/yours_login/data/mariadb
sudo rm -rf /home/yours_login/data/wordpress

# Display logs in real time
make logs
# or:
docker compose --env-file srcs/.env logs -f
```

## Installation Verification

Wait for all services to start (about 1-2 minutes) and verify:

1. **Check containers status:**
   ```bash
   docker ps
   ```
   You should see 3 running containers with (healthy) status: `nginx`, `wordpress`, `mariadb`

2. **Display logs:**
   ```bash
   make logs
   ```

3. **Access the WordPress site:**
   - Open your browser and go to: `https://yourlogin.42.fr`
   - Accept the self-signed SSL certificate
   - You should see the WordPress homepage

4. **Access the admin dashboard:**
   - URL: `https://yourlogin.42.fr/wp-admin`
   - Username: the one configured in `WP_ADMIN_USER`
   - Password: contained in `secrets/wp_admin_password.txt`


## 🔧 Troubleshooting

### Permission issues

If you encounter permission errors on volumes:
```bash
# Restart with make fclean then make up
make fclean
make up
```

### Containers won't start

```bash
# Check logs to see errors
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Complete reset

To start from scratch:

```bash
make fclean
rm -rf secrets/
make up
```

## Container Management
Other useful commands for managing containers:

```bash
# To see all containers status (including stopped ones):
docker ps -a

# To restart a specific service:
docker compose restart <service_name>

# To enter inside a container:
docker exec -it <container> /bin/bash

# To see container logs:
docker logs <container>

# To follow logs in real time:
docker compose logs -f <service_name>

# To see complete configuration:
docker inspect <container> # (<service_name>)

# To see network configuration:
docker network inspect inception

# To monitor CPU/RAM in real time:
docker stats

```

## Volume Management

```bash
# To see where volumes are mounted inside containers:
docker inspect <volume> | grep -A 10 Mounts
docker inspect <volume> | grep -A 10 Mounts

# Enter the container and view data from inside:
docker exec -it wordpress ls -la /var/www/html
docker exec -it mariadb ls -la /var/lib/mysql

```

## Data
Data is saved in two volumes:
- **mariadb volume**
- **wordpress volume** also shared with nginx in :ro (read-only)

Volume paths are absolute, data is directly on the host filesystem and defined through bind mounts in `docker-compose.yml`:
- /home/yours_login/data/mariadb
- /home/yours_login/data/wordpress

```bash
# To view volume files directly on the filesystem:
ls -la /home/yours_login/data/mariadb
ls -la /home/yours_login/data/wordpress

# To clean data you must do it manually:
sudo rm -rf /home/gvigano/data/wordpress/*
sudo rm -rf /home/gvigano/data/mariadb/*

```

## 🏗️ Architecture

The project implements a complete LEMP stack with the following components:

NGINX (Reverse Proxy) 		==>		WordPress + PHP-FPM 7.4		==>		MariaDB (Database Server)
Ports: 80 (HTTP), 443 (HTTPS)			Port: 9000 							Port: 3306