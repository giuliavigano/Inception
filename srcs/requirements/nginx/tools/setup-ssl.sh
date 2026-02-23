#!/bin/bash

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	mkdir -p /etc/nginx/ssl
 	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    		-keyout /etc/nginx/ssl/nginx.key \
    		-out /etc/nginx/ssl/nginx.crt \
    		-subj "/C=IT/ST=Lazio/L=Roma/O=42/CN=giuliaviga.42.fr"
 	chmod 600 /etc/nginx/ssl/nginx.key
 	chmod 644 /etc/nginx/ssl/nginx.crt
fi

exec "$@"