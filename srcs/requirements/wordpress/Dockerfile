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
		mariadb-client \
		netcat-openbsd && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
RUN mkdir -p /var/www/html && \
	chown -R www-data:www-data /var/www/html && \
	chmod -R 755 /var/www/html
COPY conf/wordpress.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/setup-wp.sh /usr/local/bin/setup-wp.sh
RUN chmod +x /usr/local/bin/setup-wp.sh
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/setup-wp.sh"]
CMD  ["/usr/sbin/php-fpm7.4", "-F"]
