FROM debian:bullseye
# Installa Nginx, OpenSSL (per certificati), curl (per healthcheck)
# Tutto in un solo RUN per ridurre layer e dimensioni immage 
RUN apt-get update && \
	apt-get install -y \
		nginx \
		openssl \
		curl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
# crea directory per cerificati SSL; permessi 700 = solo root puo accedere 
RUN mkdir -p /etc/nginx/ssl
RUN chmod 700 /etc/nginx/ssl
# Copia la mia configurazione Nginx e sovrascrive /etc/nginx/nginx.conf default
COPY /conf/nginx.conf /etc/nginx/nginx.conf
# Copia script che genera certificati SSL al primo avvio
# lo rende eseguibile per usarlo come ENTRYPOINT
COPY tools/setup-ssl.sh /usr/local/bin/setup-ssl.sh
RUN  chmod +x /usr/local/bin/setup-ssl.sh
# Documenta le porte su cui il container ascolta 
EXPOSE 443 80
# ENTRYPOINT = script eseguito sempre (setup certificati); CMD = comando passato a ENTRYPOINT che avvia Nginx in Foreground 
ENTRYPOINT  ["/usr/local/bin/setup-ssl.sh"]
CMD ["nginx", "-g", "daemon off;"]