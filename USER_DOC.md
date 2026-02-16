## 📋 Table of Contents

- [Services](#services)
- [Startup](#startup)
- [Verification](#service-status-verification)
- [Access](#access)

## ⚙️ Services

The project implements a LEMP environment (Linux, Nginx, MariaDB, PHP), let me explain the services that compose it:
- **Nginx**: is an HTTPS web server that has the **reverse proxy** functionality for this project, let me explain better:
	- Nginx receives HTTP requests from the Browser (from the client) and forwards them to the appropriate backend server, in this case WordPress, to then receive from WordPress and return responses to clients: Clients therefore DO NOT communicate directly with backend servers
	- However, it manages the security of sensitive information during navigation by making the communication between web Browser and Server encrypted

- **MariaDB**: the database where we store and have access to all data for the WordPress website.

- **WordPress**: backend server that creates and manages website content with a virtual interface without having to write the code manually.

***To access the website created by the project follow the next steps***

## ⏸️​ Startup

**Startup command**:
To start the services you can use the command from the 'Makefile':

```bash
make up
```

The command starts all services, declared and managed internally by docker through the docker-compose.yml file.

**Command to stop services**
If you want to ***temporarily*** stop services you can use the command:

```bash
# Stop running services:
docker compose --env-file srcs/.env stop

# They can be restarted with:
docker compose --env-file srcs/.env start
```

To stop them ***permanently*** and cleanly (removing all resources created for their current operation) instead use:

```bash
make fclean
```

## ✅​ Service Status Verification
Before accessing the website, verify that services are active and working with the command:

```bash
docker ps
```

You should see the three services ['mariadb' 'wordpress' 'nginx'] with conditions: ***up and (healthy)***


## 💿​ Access

***After starting the services***

Now you can try to ***access the WordPress site***:
- Open your Browser and visit the site `https://DOMAIN_NAME`: the DOMAIN_NAME variable is saved in the file at /srcs/.env (in the srcs folder)
- Accept the warning for the self-signed certificate and proceed
- You should see the **homepage** of the WordPress site

To access the ***administration panel*** 
- Open your Browser and visit the site `https://DOMAIN_NAME/wp-admin`
- Now you should be able to login with two users:
	- A site **administrator** user with credentials:
		- Username: in the `WP_ADMIN_USER` variable
		- Password: contained in the secrets folder, file
		`wp_admin_password.txt`
	- A **registered user** on the site with credentials:
		- Username: in the `WP_USER2` variable
		- Password: contained in the secrets folder, file `wp_user2_password.txt`

***In summary: where you can find the necessary credentials***
The **variables**:
- `DOMAIN_NAME`
- `WP_ADMIN_USER`
- `WP_USER2`
Are contained in the `.env` file in the `srcs` folder

The **passwords**:
- `wp_admin_password.txt`
- `wp_user2_password.txt`
Are contained in their respective text files in the secrets folder
