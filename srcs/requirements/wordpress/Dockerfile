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
		curl \
		wget \
		unzip \
		mariadb-client && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# ora devi installare WP_CURL --> tool da riga di comando per gestire Wordpress senza interfaccia web --> dispinibile come comando wp (usato nel .sh)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html && \
COPY conf/wordpress.conf /etc/php/7.4/fpm/pool.d/www.conf

# serve altro, indaga sui pacchetti necessari da scaricare e perchè 
COPY tools/setup-wp.sh /usr/local/bin/setup-wp.sh
RUN chmod +x /usr/local/bin/setup-wp.sh
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/setup-wp.sh"]
CMD  ["php-fpm", "-F"]

# ENTRYPOINT e CMD Insieme definiscono cosa Esegue il container
# COMANDO FINALE = ENTRYPOINT + CMD
# ENTRYPOINT = comando FISSO che viene SEMPRE Eseguito
# CMD = Argomenti Predefiniti Ma SOSTITUIBILI 

# I CMD si aggiungono al comando ENTRYPOINT e tutte le volte che vengono mandati possono essere comandi diversi 
# CMD viene passato a set-up.sh ed eseguito con exec per non lascire il PID 1 a bash e darlo al PROCESSO php-fpm -F

# =============== PACCHETTI ================

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