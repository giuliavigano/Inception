#!/bin/bash

# controllo se il database è già inizializzato oppure no:
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Database non ancora inizializzato"

	# Inizializza mariadb
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	# Avvia temporaneamente il server MariaDB / & mette in background 
	mysqld --user=mysql --skip-networking &
	temp_pid="$!"

# Aspetta che MySQL sia pronto (PERCHE SCRITTO COSÌ E NON while ! mysqladmin ping --silent; do ... ???) 
	for i in {30..0}; do
		if mysqladmin ping --silent 2>/dev/null; then
			break
		fi
		sleep 1;
	done
	if [ "$i" = 0 ]; then
		echo "Timeout: MySQL didn't respond";
		exit 1;
	fi

	# Leggi secrets
	ROOT_PWD=$(cat /run/secrets/db_root_password)
	WP_PWD=$(cat /run/secrets/db_wordpress_password)
	
	# Configura database e utenti 
	# ( User='' toglie utenti anonimi che permettono connessioni senza autenticazione)
	# PER UTENTE --> @'%' = puo connettersi da QUALSIASI host nella rete Docker
	# PER ROOT NO PERCHÈ = admin solo INTERNO al container, USER wordrepress DEVE CONNETTERSI da container wordpress
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
	
	# Chisura MySQL temporaneo --> PRIMA kill $temp_pid /n wait $temp_pid ??
	if ! kill -s TERM "$temp_pid" || ! wait "$temp_pid"; then
		echo "Error, closure failure of MySQL"
		exit 1
	fi
	
	echo "Inizzializzazione completa!"
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