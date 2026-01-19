# debian o alpine ??
FROM debian:bullseye
RUN apt-get update && apt-get install -y nginx openssl curl


COPY
EXPOSE 443 80
# esecuzione diretta senza shell intermendia con CMD -->
CMD  ["nginx", "-g", "daemon off;"]
# daemon off --> processo volutamente in foreground


# SE SERVE CONFIGURAZIONE DINAMICA CON FILE CONFIG.SH -->
FROM debian:bullseye
RUN
COPY
EXPOSE 443 80
COPY  /configure.sh
RUN  chmod +x /configure.sh
ENTRYPOINT  ["/configure.sh"]
CMD ["nginx", "-g", "daemon off;"]