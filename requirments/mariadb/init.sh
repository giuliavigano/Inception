#!/bin/bash

exec $@

# Responsabilità dello script:

# Al primo avvio (database non inizializzato):

# Inizializza MariaDB (mysql_install_db)
# Avvia MariaDB temporaneamente
# Leggi password dai secrets
# Crea database wordpress
# Crea utente wordpress con password
# Dai privilegi all'utente
# Ferma MariaDB temporaneo
# Avvia MariaDB definitivo in foreground
# Agli avvii successivi (database già esiste):

# Skip inizializzazione (dati persistiti dal volume)
# Avvia MariaDB direttamente in foreground