FROM debian:bullseye
RUN apt-get update && \
	apt-get install -y mariadb-server mariadb-client && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
COPY configuration.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY init.sh
RUN chmod +x /init.sh
EXPOSE 3306
ENTRYPOINT ["/init.sh"]
CMD  ["mysqld"]