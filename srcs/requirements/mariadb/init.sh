#!/bin/bash

# controllo se il database è già inizializzato oppure no:
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Database non ancora inizializzato"
	mysql_install_db --user=mysql --datadir=/var/lib/mysql #inizializza mariadb
	mysqld --user=mysql & # avvia il server MariaDB / & mette in background 
	temp_pid=$!
	while ! mysqladmin ping --silent; do
		sleep 1
	done
	# prima devo chiederle e impostarle giusto OPPURE sono gia nei file di testo ??
	ROOT_PWD=$(cat /run/secrets/db_root_password)
	WP_PWD=$(cat /run/secrets/db_wordpress_password)
	mysqladmin -u root password "$ROOT_PWD"
	mysql -u root -p"$ROOT_PWD" << EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER 'wordpress'@'%' IDENTIFIED BY '$WP_PWD';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';
FLUSH PRIVILEGES;
EOF
	echo "Inizzializzazione completa, riavvio MariaDB..."
	kill $temp_pid
	wait $temp_pid
else
	echo "Database già inizializzato, avvio MariaDB..."
fi

exec "$@" # che sarebbe mysqld di CMD ["mysqld"]


# Responsabilità dello script:

# Al primo avvio (database non inizializzato):

# Inizializza MariaDB (mysql_install_db)
# Avvia MariaDB temporaneamente
# Leggi password dai secrets
# Crea database wordpress
# Crea utente wordpress con password
# Dai privilegi all'utente
# Ferma MariaDB temporaneo
# Avvia MariaDB definitivo in foreground
# Agli avvii successivi (database già esiste):

# Skip inizializzazione (dati persistiti dal volume)
# Avvia MariaDB direttamente in foreground