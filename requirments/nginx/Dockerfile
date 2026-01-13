# debian o alpine ??
FROM
RUN
COPY
EXPOSE 443 80
CMD  ["nginx", "-g", "daemon off;"] 
# daemon off --> processo volutamente in foreground


# SE SERVE CONFIGURAZIONE DINAMICA CON FILE CONFIG.SH -->
FROM
RUN
COPY
COPY  /configure.sh
RUN  chmod +x /configure.sh
ENTRYPOINT  ["/configure.sh"]
CMD ["nginx", "-g", "daemon off;"]