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
	ADMIN_PWD=$(cat /run/secrets/wp_admin_password)
	USER2_PWD=$(cat /run/secrets/wp_user2_password)

# COMANDI WP-CLI che configurano WordPress in FASI:

# Crea i file di CONFIGURAZIONE
# Crea il file wp-config.php ( FILE DI CONFIG. PRINCIPALE DI WORDPRESS )
# Stabilisce la connessione con il DATABASE (Nome DB, Utente, Password, Host)
	wp config create \
		--dbname="$WORDPRESS_DB_NAME" \
		--dbuser="$WORDPRESS_DB_USER" \
		--dbpass="$DB_PWD" \
		--dbhost="$WORDPRESS_DB_HOST" \
		--allow-root

# Installa wordpress
# Crea le TABELLE nel DATABASE (wp_posts, wp_users ecc... ) ??
# CONFIGURA il sito: URL, titolo
# CREA il primo Utente amministratore con CREDENZIALI specificate
# Rende WordPress EFFETTIVAMENTE FUNZIONANTE

# Dopo Questo comando il sito è ACCESSIBILE e OPERATIVO
	wp core install \
		--url="https://$DOMAIN_NAME" \
		--title="My Site" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$ADMIN_PWD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--allow-root

# Aggiunge Utenti EXTRA 
# Crea un secondo utente con RUOLO "Author" ( puo' scrivere articoli ma non MODIFICARE Impostazioni )
# Si esegue DOPO l'installazione perche si richiede che il Database WORDPRESS esista GIÀ
	wp user create "$WP_USER2" "$WP_USER2_EMAIL" \
		--role=author \
		--user_password="$USER2_PWD" \
		--allow-root 
	
	unset DB_PWD
	unset ADMIN_PWD
	unset USER2_PWD
fi

exec "$@"

# exec --> SOSTITUISCE il processo correte (bash) con un NUOVO PROCESSO: Quello passato come argomento
# RIMPIAZZA bash con il processo di CMD php-fpm 