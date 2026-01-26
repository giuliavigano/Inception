#!/bin/bash

while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
		sleep 1
done

cd /var/www/html
if [ ! -f wp-config.php ]; then

	wp core download --allow-root

	DB_PWD=$(cat /run/secrets/db_wordpress_password)
	WORDPRESS_DB_PWD=(cat /run/secrets/db_wordpress_password)
	ADMIN_PWD=$(cat /run/secrets/wp_admin_password)
	USER2_PWD=$(cat /run/secrets/wp_user2_password)

	wp config create \
		--dbname="$WORDPRESS_DB_NAME" \
		--dbuser="$WORDPRESS_DB_USER" \
		--dbpass="$WORDPRESS_DB_PWD" \
		--dbhost="$WORDPRESS_DB_HOST" \
		--allow-root

# installa wordpress
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