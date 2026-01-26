#!/bin/bash

# Controlla che mariadb sia funzionanate
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
		sleep 1
done

# Crea cartella dove, in standard, viene istallato wordpress nei server linux
# Document room predefinita di Nginx
# Il punto dove web-server cerca i file da SERVIRE ai visitatori quando riceve richieste HTTP
cd /var/www/html

# 1. Nginx è CONFIGURATO per puntare a questa directory come root del sito
# 2. PHP-FPM processa i file .php trovati qui
# 3. Wordpress si aspetta di essere eseguito da questa posizione per funzionare correttamente

if [ ! -f wp-config.php ]; then

# Scarica tutti i file di WordPress
	wp core download --allow-root

	DB_PWD=$(cat /run/secrets/db_wordpress_password)
	WORDPRESS_DB_PWD=(cat /run/secrets/db_wordpress_password)
	ADMIN_PWD=$(cat /run/secrets/wp_admin_password)
	USER2_PWD=$(cat /run/secrets/wp_user2_password)

# COMANDI WP-CLI che configurano WordPress in FASI:

	wp config create \
		--dbname="$WORDPRESS_DB_NAME" \
		--dbuser="$WORDPRESS_DB_USER" \
		--dbpass="$WORDPRESS_DB_PWD" \
		--dbhost="$WORDPRESS_DB_HOST" \
		--allow-root

# Installa wordpress
	wp core install \
		--url="https://$DOMAIN_NAME" \
		# --title="My Site" \ ???
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$ADMIN_PWD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--allow-root

	wp user create "$WP_USER2" "$WP_USER2_EMAIL" \
		--role=author \
		--user_password="$USER2_PWD" \
		--allow-root 
	
fi

exec "$@"