#!/bin/bash

while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
		sleep 1
done

cd /var/www/html
if [ ! -f wp-config.php ]; then
	wp core download --allow-root
	DB_PWD=$(cat /run/secrets/db_wordpress_password)
	wp config create \
	
fi

ADMIN_PWD=$(cat /run/secrets/wp_admin_password)
USER2_PWD=$(cat /run/secrets/wp_user2_password)

wp core install \
	--admin_user="$WP_ADMIN_USER" \
	--admin_password="$ADMIN_PWD" \
	--admin_email="$WP_ADMIN_EMAIL"

wp user create "$WP_USER2" "$WP_USER2_EMAIL" \
	--user_password="$USER2_PWD"
	--role=editor

exec "$@"