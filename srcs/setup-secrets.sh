#!/bin/bash

mkdir -p secrets

read -sp "Password for root MariaDB: " DB_ROOT_PWD
echo
read -sp "Password for wordpress database user : " DB_WP_PWD
echo
read -sp "Password for admin wordpress (gvigano): " WP_ADMIN_PWD
echo
read -sp "Password for wordpress user2 : " WP_USER2_PWD
echo

echo "$DB_ROOT_PWD" > ../secrets/db_root_password.txt
echo "$DB_WP_PWD" > ../secrets/db_wordpress_password.txt
echo "$WP_ADMIN_PWD" > ../secrets/wp_admin_password.txt
echo "$WP_USER2_PWD" > ../secrets/wp_user2_password.txt

chmod 600 ../secrets/*