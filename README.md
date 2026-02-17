*This project has been created as part of the 42 curriculum by gvigano*

## 📋 Table of Contents

- [Description](#-description)
- [Architecture](#️-architecture)
- [Instructions](#instructions)
- [Project Description](#project-description)
- [Technical Notes](#-technical-notes)
- [Useful Resources](#-useful-resources)

## 🎯 Description

Inception is a system administration and Docker infrastructure project that implements a complete LEMP environment (Linux, Nginx, MariaDB, PHP) using Docker Compose; with WordPress as the main web application.
The goal is to configure a small infrastructure composed of different services following these requirements:

 - A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
 - A Docker container that contains WordPress + php-fpm (it must be installed and configured) only, without nginx.
 - A Docker container that contains MariaDB only, without nginx.
 - A volume that contains your WordPress database.
 - A second volume that contains your WordPress website files.
 - A docker-network that establishes the connection between your containers.
 - Your containers have to restart in case of a crash

And these ***specific rules***:
- Containers must be built from custom Docker images, implemented and not downloaded
- The entire infrastructure must be orchestrated with Docker Compose
- Data must persist using Docker volumes

## 🏗️ Architecture

The project implements a complete LEMP stack with the following components:

NGINX (Reverse Proxy) 		==>		WordPress + PHP-FPM 7.4		==>		MariaDB (Database Server)
Ports: 80 (HTTP), 443 (HTTPS)			Port: 9000 							Port: 3306

## Instructions

```bash
# 1. Clone the repo
git clone <repo>
cd inception

# 2. Customize configuration (see DEV_DOC.md)
vim srcs/.env	# Set your login instead of 'gvigano'
vim Makefile	# Adjust volume paths in 'setup:' and 'fclean'

# 3. Start
make

# 4. Open browser with the login you modified in the configuration
https://yours_login.42.fr
```

## 🔈Project Description

### Virtual Machine Vs Docker
- **Virtual Machine**: Has dedicated RAM, disk, OS --> includes an entire guest OS + hypervisor (HEAVY, GB of RAM, minutes to boot)

- **Docker**: Shares the Linux Kernel of the host --> includes only the application and its dependencies (MB, seconds to start)

- **Isolation**: VM = complete hardware isolation (very secure), Docker = process-level isolation

- **Portability**: Docker Containers are portable

- **When to use one or the other**: VM for total isolation/critical security, Docker for microservices/development/rapid deployment

### Secrets Vs Environment Variables
- **Secrets**:
	- Mounted as files in /run/secrets/<secret_name>, temporary files in RAM deleted on stop.
	- Don't appear in docker history
	- Only authorized containers have access

- **Env vars**:
	- Visible with 'docker inspect'
	- Saved in image layer
	- Visible in logs (if printed)
	- Appear in docker history
	- Anyone with container access has access

**Best Practice**:
- Secrets for passwords/API keys
- Env vars for non-sensitive configurations

### Docker Network Vs Host Network
- **Docker Network**:
	- Isolated network with private subnet
	- Automatic internal DNS (resolves service names)
	- Ports not exposed to host, only explicitly if needed
	- **security** Containers not reachable from outside

- **Host Network**:
	- Container uses host network directly
	- Better performance but **zero isolation**

**Docker Network** for: isolation, DNS management, ability to have multiple separate networks

### Docker Volumes Vs Bind Mounts
- **Docker Volumes**:
	- Created by Docker in /var/lib/docker/volumes/
	- Completely managed by Docker
	- Available commands: *docker volume create*, *docker volume ls*, *docker volume rm*
	- You don't have to worry about permissions/ownership
- **Bind Mounts**:
	- *Absolute path* of host mounted in container
	- You manage: permissions/ownership/backup
	- Useful for development, immediate changes
	- *Problem*: dependency on host filesystem

**Docker Volumes** required for this project 

## 📝 Technical Notes

This project was developed as part of the 42 curriculum.

### Implemented Features

- **Custom Docker images**: Containers use Debian Bullseye only as base image
- **Security**: 
  - Automatically generated self-signed SSL certificates
  - Passwords managed through Docker secrets and randomly generated with openssl, no hardcoded passwords in code
- **Orchestration**: Services start sequentially thanks to health checks and depend_on (first mariadb then wordpress and finally Nginx)
- **Persistence**: WordPress and MariaDB data is persistent through volumes
- **Best practices**: 
  - Service isolation: each container runs a single main process
  - PID 1 management: main processes (nginx, php-fpm, mysqld) are executed in foreground as PID 1 to properly handle system signals (SIGTERM, SIGINT)
  - Restart policy `unless-stopped`: containers restart automatically in case of crash but can be stopped manually
  - Network isolation: communication between containers through dedicated `inception` network

### Volume Structure

- `/home/yourlogin/data/wordpress` → Contains WordPress files (wp-content, themes, plugins) also shared with Nginx in :ro for reverse proxy
- `/home/yourlogin/data/mariadb` → Contains MariaDB database

### Generated Secrets

Secrets are automatically and randomly generated with OpenSSL and saved in `secrets/`:
- `db_root_password.txt` → MariaDB root password
- `db_wordpress_password.txt` → WordPress database user password
- `wp_admin_password.txt` → WordPress administrator password
- `wp_user2_password.txt` → Second WordPress user password

## 📚 Useful Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Video](https://www.youtube.com/watch?v=3c-iBn73dDE&t=117ss)
- [WordPress Official Documentation](https://wordpress.org/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.org/documentation/)
- [NGINX Documentation](https://nginx.org/en/docs/)

The use of AI (Claude Sonnet 4.5) in this project was limited to theoretical questions, mostly description of my reasoning and acquired connections and checking their theoretical validity (considering that the more I progressed in the study the more I discovered new things, I preferred to try to correct my reasoning as soon as possible and step by step, when I didn't have the possibility to do so with a classmate at school). For validity, it was very helpful to also question new theoretical concepts (or at least the explanation provided by AI), for my complete understanding before working on its practical implementation.

The use of AI (Claude Sonnet 4.5) also helped me in implementing this file regarding Markdown syntax, for example to correctly format code blocks with bash syntax highlighting, thus in studying the correct syntax.