FROM debian:bullseye
RUN 
EXPOSE 3306
COPY configuration.cnf
COPY init.sh
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]
CMD  ["mysqld"]