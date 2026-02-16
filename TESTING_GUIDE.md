# Guida Completa al Testing - Inception Project

## Indice
1. [Setup Iniziale e Build](#setup-iniziale-e-build)
2. [Comandi Docker Essenziali](#comandi-docker-essenziali)
3. [Test Obbligatori per la Mandatory Part](#test-obbligatori)
4. [Test di Persistenza Dati](#test-persistenza)
5. [Test di Rete e Sicurezza](#test-rete-sicurezza)
6. [Troubleshooting e Debug](#troubleshooting)

---

## 1. Setup Iniziale e Build {#setup-iniziale-e-build}

### 1.1 Preparazione Secrets
```bash
# Verifica che i file secrets esistano
ls -la secrets/

# Controlla il contenuto (per verificare che non siano vuoti)
cat secrets/db_root_password.txt
cat secrets/db_wordpress_password.txt
cat secrets/wp_admin_password.txt
cat secrets/wp_user2_password.txt
```

### 1.2 Build del Progetto
```bash
# Pulizia completa (se necessario)
make fclean

# Build delle immagini
make build

# Avvio dei container
make up

# OPPURE tutto insieme
make
```

### 1.3 Verifica Build Corretta
```bash
# Verifica che le immagini siano state create
docker images

# Dovresti vedere:
# - inception-nginx
# - inception-wordpress
# - inception-mariadb
```

---

## 2. Comandi Docker Essenziali {#comandi-docker-essenziali}

### 2.1 Gestione Container

```bash
# Lista tutti i container in esecuzione
docker ps

# Lista tutti i container (anche quelli fermati)
docker ps -a

# Verifica i dettagli di un container specifico
docker inspect <container_name>

# Verifica i log di un container
docker logs <container_name>

# Segui i log in tempo reale
docker logs -f <container_name>

# Ultimi 50 righe di log
docker logs --tail 50 <container_name>

# Entra in un container (eseguire comandi dentro)
docker exec -it <container_name> /bin/bash
# oppure
docker exec -it <container_name> sh

# Verifica i processi in un container
docker top <container_name>

# Verifica le statistiche (CPU, RAM, etc.)
docker stats

# Verifica le statistiche di un container specifico
docker stats <container_name>
```

### 2.2 Gestione Volumi

```bash
# Lista tutti i volumi
docker volume ls

# Verifica dettagli di un volume specifico
docker volume inspect <volume_name>

# Trova dove è montato fisicamente un volume
docker volume inspect <volume_name> | grep Mountpoint

# Rimuovi volumi non utilizzati
docker volume prune

# Rimuovi un volume specifico (solo se non in uso)
docker volume rm <volume_name>
```

### 2.3 Gestione Network

```bash
# Lista tutte le reti
docker network ls

# Verifica dettagli di una rete specifica
docker network inspect <network_name>

# Verifica quali container sono connessi a una rete
docker network inspect <network_name> | grep -A 10 Containers

# Rimuovi reti non utilizzate
docker network prune
```

### 2.4 Docker Compose

```bash
# Avvia i servizi
docker-compose up -d

# Ferma i servizi
docker-compose down

# Ferma e rimuovi volumi
docker-compose down -v

# Verifica lo stato dei servizi
docker-compose ps

# Verifica i log di tutti i servizi
docker-compose logs

# Verifica i log di un servizio specifico
docker-compose logs <service_name>

# Rebuild di un servizio specifico
docker-compose build <service_name>

# Restart di un servizio
docker-compose restart <service_name>

# Stop di un servizio specifico
docker-compose stop <service_name>

# Start di un servizio specifico
docker-compose start <service_name>
```

### 2.5 Pulizia Sistema

```bash
# Rimuovi container, network, immagini non utilizzate
docker system prune

# Rimuovi tutto (inclusi volumi) - ATTENZIONE!
docker system prune -a --volumes

# Verifica spazio utilizzato da Docker
docker system df
```

---

## 3. Test Obbligatori per la Mandatory Part {#test-obbligatori}

### 3.1 Verifica Container in Esecuzione

```bash
# STEP 1: Verifica che tutti i container siano up
docker ps

# OUTPUT ATTESO: 3 container in esecuzione
# - nginx
# - wordpress
# - mariadb

# STEP 2: Verifica lo stato di salute
docker-compose ps

# Tutti devono essere "Up" (non "Exit" o "Restarting")
```

### 3.2 Test di MariaDB

```bash
# STEP 1: Entra nel container MariaDB
docker exec -it mariadb /bin/bash

# STEP 2: Connettiti a MySQL/MariaDB
mysql -u root -p
# Inserisci la password da secrets/db_root_password.txt

# STEP 3: Verifica database WordPress
SHOW DATABASES;
# Dovresti vedere il database 'wordpress'

USE wordpress;
SHOW TABLES;
# Dovresti vedere le tabelle WordPress (wp_posts, wp_users, etc.)

# STEP 4: Verifica utente WordPress
SELECT User, Host FROM mysql.user;
# Dovresti vedere l'utente WordPress

# STEP 5: Esci
exit
exit
```

### 3.3 Test di WordPress

```bash
# STEP 1: Verifica che WordPress-CLI sia installato
docker exec wordpress which wp

# STEP 2: Entra nel container WordPress
docker exec -it wordpress /bin/bash

# STEP 3: Verifica installazione WordPress
wp core is-installed --allow-root
# Dovrebbe restituire exit code 0 (successo)

# STEP 4: Verifica utenti WordPress
wp user list --allow-root
# Dovresti vedere:
# - wp_admin (administrator)
# - wp_user2 (subscriber o simile)

# STEP 5: Verifica configurazione
wp config list --allow-root

# STEP 6: Verifica connessione al database
wp db check --allow-root

# STEP 7: Esci
exit
```

### 3.4 Test di NGINX

```bash
# STEP 1: Verifica che NGINX sia in esecuzione
docker exec nginx nginx -t
# Dovrebbe dire "syntax is ok" e "test is successful"

# STEP 2: Verifica la configurazione SSL
docker exec nginx cat /etc/nginx/conf.d/default.conf
# Verifica che ci siano:
# - listen 443 ssl
# - ssl_certificate e ssl_certificate_key
# - ssl_protocols TLSv1.2 TLSv1.3

# STEP 3: Verifica certificati SSL
docker exec nginx ls -la /etc/nginx/ssl/
# Dovresti vedere i certificati SSL

# STEP 4: Test dal browser
# Apri: https://<tuo_domain_name> (es. https://gviga.42.fr)
# Dovresti vedere WordPress
```

### 3.5 Test di Accesso WEB

```bash
# STEP 1: Test con curl (HTTP -> dovrebbe redirect a HTTPS)
curl -I http://<tuo_domain_name>
# Dovrebbe restituire un redirect 301 o 302

# STEP 2: Test HTTPS
curl -k https://<tuo_domain_name>
# Dovrebbe restituire HTML di WordPress

# STEP 3: Test TLS version
openssl s_client -connect <tuo_domain_name>:443 -tls1_2
# Dovrebbe connettersi

openssl s_client -connect <tuo_domain_name>:443 -tls1_3
# Dovrebbe connettersi

openssl s_client -connect <tuo_domain_name>:443 -tls1_1
# Dovrebbe FALLIRE (TLSv1.1 non supportato)

# STEP 4: Accesso da browser
# Vai su: https://<tuo_domain_name>
# Verifica:
# - Il sito WordPress si carica
# - Il certificato SSL è presente (lucchetto nel browser)
```

### 3.6 Test Login WordPress

```bash
# STEP 1: Vai al pannello admin
# Browser: https://<tuo_domain_name>/wp-admin

# STEP 2: Login come amministratore
# Username: wp_admin (o come configurato)
# Password: da secrets/wp_admin_password.txt

# STEP 3: Verifica pannello WordPress
# - Dovresti vedere la dashboard di WordPress
# - Verifica che ci siano 2 utenti (Settings -> Users)

# STEP 4: Logout e login come secondo utente
# Username: wp_user2 (o come configurato)
# Password: da secrets/wp_user2_password.txt
```

---

## 4. Test di Persistenza Dati {#test-persistenza}

### 4.1 Test Volume WordPress

```bash
# STEP 1: Crea un post di test
# Vai su WordPress admin -> Posts -> Add New
# Crea un post con titolo "Test Persistenza"
# Pubblica il post

# STEP 2: Ferma i container
docker-compose down

# STEP 3: Verifica che i volumi esistano ancora
docker volume ls
# Dovresti vedere i volumi di WordPress e MariaDB

# STEP 4: Riavvia i container
docker-compose up -d

# STEP 5: Verifica che il post esista ancora
# Vai su WordPress e controlla che "Test Persistenza" ci sia ancora
```

### 4.2 Test Volume MariaDB

```bash
# STEP 1: Entra in MariaDB e crea una tabella di test
docker exec -it mariadb mysql -u root -p
USE wordpress;
CREATE TABLE test_persistence (id INT, message VARCHAR(100));
INSERT INTO test_persistence VALUES (1, 'Dati persistenti');
SELECT * FROM test_persistence;
exit

# STEP 2: Ferma i container
docker-compose down

# STEP 3: Riavvia
docker-compose up -d

# STEP 4: Verifica che la tabella esista
docker exec -it mariadb mysql -u root -p
USE wordpress;
SELECT * FROM test_persistence;
# Dovrebbe mostrare il record inserito

# STEP 5: Pulizia
DROP TABLE test_persistence;
exit
```

### 4.3 Test Distruzione Completa e Ricostruzione

```bash
# STEP 1: Ferma e rimuovi tutto (TRANNE i volumi)
docker-compose down

# STEP 2: Rimuovi le immagini
docker rmi inception-nginx inception-wordpress inception-mariadb

# STEP 3: Rebuild completo
make re

# STEP 4: Verifica che i dati persistano ancora
# - Il sito WordPress dovrebbe essere ancora configurato
# - I post dovrebbero esistere
# - Gli utenti dovrebbero esistere
```

---

## 5. Test di Rete e Sicurezza {#test-rete-sicurezza}

### 5.1 Verifica Network Isolation

```bash
# STEP 1: Verifica che esista una rete Docker custom
docker network ls
# Dovresti vedere la tua rete (es. inception_network)

# STEP 2: Verifica che i container siano sulla stessa rete
docker network inspect <network_name>
# Tutti e tre i container devono essere nella lista

# STEP 3: Verifica connettività INTERNA tra container
# Da WordPress a MariaDB
docker exec wordpress ping -c 3 mariadb
# Dovrebbe funzionare

# Da NGINX a WordPress
docker exec nginx ping -c 3 wordpress
# Dovrebbe funzionare
```

### 5.2 Verifica Port Exposure

```bash
# STEP 1: Verifica quali porte sono esposte
docker ps
# Solo la porta 443 di NGINX dovrebbe essere mappata sull'host

# STEP 2: Verifica che MariaDB non sia accessibile dall'esterno
telnet <tuo_ip> 3306
# Dovrebbe FALLIRE (connection refused)

# STEP 3: Verifica che WordPress non sia direttamente accessibile
curl http://<tuo_ip>:9000
# Dovrebbe FALLIRE
```

### 5.3 Verifica Restart Policy

```bash
# STEP 1: Verifica restart policy
docker inspect <container_name> | grep -A 3 RestartPolicy
# Dovrebbe essere "always" o "unless-stopped"

# STEP 2: Test restart automatico
docker stop mariadb

# STEP 3: Attendi alcuni secondi e verifica
docker ps
# MariaDB dovrebbe essere riavviato automaticamente
```

---

## 6. Troubleshooting e Debug {#troubleshooting}

### 6.1 Container Non Si Avvia

```bash
# STEP 1: Verifica i log
docker-compose logs <service_name>

# STEP 2: Verifica errori specifici
docker logs <container_name> --tail 100

# STEP 3: Prova ad avviare in modalità interattiva
docker run -it <image_name> /bin/bash
```

### 6.2 Problema di Connessione Database

```bash
# STEP 1: Verifica che MariaDB sia pronto
docker exec mariadb mysqladmin ping -u root -p

# STEP 2: Verifica connettività di rete
docker exec wordpress ping mariadb

# STEP 3: Verifica variabili d'ambiente
docker exec wordpress env | grep DB
```

### 6.3 Problema NGINX/SSL

```bash
# STEP 1: Verifica configurazione
docker exec nginx nginx -t

# STEP 2: Verifica certificati
docker exec nginx openssl x509 -in /etc/nginx/ssl/nginx.crt -text -noout

# STEP 3: Verifica permessi
docker exec nginx ls -la /etc/nginx/ssl/
```

### 6.4 WordPress Non Risponde

```bash
# STEP 1: Verifica PHP-FPM
docker exec wordpress ps aux | grep php

# STEP 2: Verifica connessione al database
docker exec wordpress wp db check --allow-root

# STEP 3: Verifica file WordPress
docker exec wordpress ls -la /var/www/html/
```

### 6.5 Pulizia e Reset Completo

```bash
# ATTENZIONE: Questo cancellerà TUTTI i dati!

# STEP 1: Ferma tutto
docker-compose down -v

# STEP 2: Rimuovi le immagini
make fclean

# STEP 3: Rimuovi volumi manualmente (se necessario)
docker volume rm $(docker volume ls -q | grep inception)

# STEP 4: Rebuild da zero
make
```

---

## 7. Checklist Pre-Defense

### Setup e Configurazione
- [ ] File .env configurato correttamente (DOMAIN_NAME, etc.)
- [ ] Tutti i secrets sono configurati
- [ ] Makefile funziona correttamente (make, make clean, make fclean, make re)
- [ ] docker-compose.yml è corretto

### Container
- [ ] Tutti e 3 i container si avviano correttamente
- [ ] Container hanno restart policy configurata
- [ ] Ogni servizio ha il proprio Dockerfile
- [ ] Nessun container usa immagini pre-built (no nginx:latest, etc.)

### Volumi
- [ ] Volume per WordPress configurato
- [ ] Volume per MariaDB configurato
- [ ] I dati persistono dopo restart
- [ ] I volumi sono nominati correttamente

### Network
- [ ] Esiste una rete Docker custom
- [ ] I container comunicano tra loro
- [ ] Solo la porta 443 è esposta

### NGINX
- [ ] TLSv1.2 e TLSv1.3 sono supportati
- [ ] TLSv1.0 e TLSv1.1 NON sono supportati
- [ ] Certificati SSL funzionano
- [ ] Redirect HTTP -> HTTPS funziona (se implementato)

### WordPress
- [ ] WordPress è installato e configurato
- [ ] WP-CLI funziona
- [ ] Due utenti esistono
- [ ] Login amministratore funziona
- [ ] Login secondo utente funziona
- [ ] Connessione al database funziona

### MariaDB
- [ ] Database WordPress esiste
- [ ] Utente WordPress esiste
- [ ] Tabelle WordPress sono create
- [ ] Non è accessibile dall'esterno

### Documentazione
- [ ] README.md completo
- [ ] USER_DOC.md presente
- [ ] DEV_DOC.md presente

---

## 8. Comandi Rapidi Durante la Defense

```bash
# Mostra tutto il setup in un colpo d'occhio
docker-compose ps && docker volume ls && docker network ls

# Verifica che tutto sia in salute
docker stats --no-stream

# Mostra i log recenti di tutti i servizi
docker-compose logs --tail 20

# Dimostra la persistenza
docker-compose down && docker volume ls && docker-compose up -d

# Entra rapidamente in ogni container
docker exec -it nginx sh
docker exec -it wordpress bash
docker exec -it mariadb bash

# Verifica configurazione WordPress
docker exec wordpress wp --info --allow-root

# Verifica database
docker exec mariadb mysql -u root -p -e "SHOW DATABASES;"
```

---

## Note Finali

### Cose da Sapere per la Defense

1. **Virtual Machines vs Docker**: 
   - VM virtualizza hardware completo
   - Docker condivide il kernel dell'host (più leggero)

2. **Secrets vs Environment Variables**:
   - Secrets sono più sicuri (file separati, permessi limitati)
   - Env variables possono essere viste con `docker inspect`

3. **Docker Network vs Host Network**:
   - Docker Network isola i container
   - Host Network usa la rete dell'host direttamente

4. **Docker Volumes vs Bind Mounts**:
   - Volumes gestiti da Docker (preferiti)
   - Bind mounts mappano cartelle dell'host

### Errori Comuni da Evitare

- ❌ Non usare `network: host` nel docker-compose
- ❌ Non esporre porte non necessarie
- ❌ Non usare immagini pre-built di Alpine/Debian
- ❌ Non mettere password in chiaro nel docker-compose
- ❌ Non usare latest nelle immagini base
- ❌ Non avviare container con loop infiniti inutili (tail -f)

Buona fortuna con il progetto! 🚀
