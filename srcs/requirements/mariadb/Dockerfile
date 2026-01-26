FROM debian:bullseye
RUN apt-get update && \
	apt-get install -y mariadb-server mariadb-client && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh
EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD  ["mysqld", "--user=mysql"]