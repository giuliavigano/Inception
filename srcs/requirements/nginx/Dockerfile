FROM debian:bullseye
RUN apt-get update && \
	apt-get install -y \
		nginx \
		openssl \
		curl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/nginx/ssl
RUN chmod 700 /etc/nginx/ssl
COPY /conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup-ssl.sh /usr/local/bin/setup-ssl.sh
RUN  chmod +x /usr/local/bin/setup-ssl.sh
EXPOSE 443 80
ENTRYPOINT  ["/usr/local/bin/setup-ssl.sh"]
CMD ["nginx", "-g", "daemon off;"]