FROM debian:bullseye
RUN apt-get update && \
	apt-get install -y \
		php-fpm \ 
		php-mysql \
		php-mysqli \
		php-curl \
		php-gd \
		php-xml \
		php-mbstring \
		php-zip \
		cutl \
		wget \
		unzip \
		mariadb-client && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# ora devi installare WP_CURL --> tool da riga di comando per gestire Wordpress senza interfaccia web --> dispinibile come comando wp (usato nel .sh)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# serve altro, indaga sui pacchetti necessari da scaricare e perchè 
COPY /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD  ["php-fpm", "-F"]

#php-mysql        # Connessione a MySQL/MariaDB
#php-mysqli       # Driver MySQL migliorato
#php-curl         # Per scaricare cose da internet
#php-gd           # Elaborazione immagini
#php-xml          # Parsing XML
#php-mbstring     # Gestione stringhe multibyte
#php-zip          # Compressione/decompressione

#curl o wget      # Per scaricare WordPress e WP-CLI
#unzip            # Per decomprimere archivi
#mariadb-client   # Tool mysql per testare connessione DB