#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Database non ancora inizializzato"

	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	mysqld --user=mysql --skip-networking &
	temp_pid="$!"

	for i in {0..30}; do
		if mysqladmin ping --silent 2>/dev/null; then
			break
		fi
		sleep 1;
	done
	if [ "$i" = 0 ]; then
		echo "Timeout: MySQL didn't respond";
		exit 1;
	fi

	ROOT_PWD=$(cat /run/secrets/db_root_password)
	WP_PWD=$(cat /run/secrets/db_wordpress_password)
	
	mysql -u root  << EOF
CREATE USER IF NOT EXISTS 'healthcheck'@'localhost';
GRANT USAGE ON *.* TO 'healthcheck'@'localhost';
FLUSH PRIVILEGES;
EOF

	mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PWD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$WP_PWD';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	unset ROOT_PWD
	unset WP_PWD

	if ! kill -s TERM "$temp_pid" || ! wait "$temp_pid"; then
		echo "Error, closure failure of MySQL"
		exit 1
	fi
	
	echo "Inizzializzazione completa!"
else
	echo "Database già inizializzato, avvio MariaDB..."
fi

exec "$@" 

# FLUSH PRIVILEGES;
# EOF

# 	mysql -u root -p"$ROOT_PWD" << EOF
# DROP USER IF EXISTS 'root'@'localhost';
# DROP USER IF EXISTS 'root'@'127.0.0.1';
# DROP USER IF EXISTS 'root'@'::1';