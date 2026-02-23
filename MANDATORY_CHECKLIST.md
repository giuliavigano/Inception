<!-- # ✅ CHECKLIST VERIFICA PROGETTO INCEPTION - PARTE MANDATORY

## 📁 STRUTTURA DEL PROGETTO

- [ ] Il progetto è nella cartella `srcs/`
- [ ] Il file `docker-compose.yml` è presente nella root del progetto
- [ ] Il file `Makefile` è presente nella root del progetto
- [ ] File `.env` presente in `srcs/.env` (non committato su Git)
- [ ] File `.env` contiene solo variabili d'ambiente, **NO PASSWORD IN CHIARO** -->

<!-- ## 🐳 DOCKERFILE E CONTAINER

### Container Requirements
- [ ] **3 container separati**: NGINX, WordPress, MariaDB
- [ ] Ogni container ha il proprio Dockerfile
- [ ] I Dockerfile sono basati su **penultima versione stabile** (Debian Bullseye o Alpine)
- [ ] **NO latest tag** nei Dockerfile
- [ ] **NO immagini già pronte** (no wordpress:latest, no nginx:alpine, etc.)
- [ ] Ogni Dockerfile installa e configura il servizio manualmente

### NGINX Container
- [ ] Dockerfile presente in `srcs/requirements/nginx/Dockerfile`
- [ ] Basato su Debian Bullseye o Alpine
- [ ] Installa NGINX manualmente
- [ ] Supporta **solo TLSv1.2 o TLSv1.3**
- [ ] Configurato con certificato SSL/TLS
- [ ] Espone le porte **443** (e opzionalmente 80 con redirect)
- [ ] **NO daemon mode** (nginx -g "daemon off;")
- [ ] Ha uno script di setup per i certificati SSL -->

<!-- ### WordPress Container
- [ ] Dockerfile presente in `srcs/requirements/wordpress/Dockerfile`
- [ ] Basato su Debian Bullseye o Alpine
- [ ] Installa **PHP-FPM** manualmente (no Apache, no NGINX)
- [ ] Installa WordPress manualmente (tramite wp-cli o download)
- [ ] **NON deve contenere NGINX**
- [ ] Espone porta **9000** (PHP-FPM)
- [ ] Ha uno script di configurazione/setup
- [ ] **NO daemon mode** per PHP-FPM (-F flag) -->

<!-- ### MariaDB Container
- [ ] Dockerfile presente in `srcs/requirements/mariadb/Dockerfile`
- [ ] Basato su Debian Bullseye o Alpine
- [ ] Installa MariaDB manualmente
- [ ] **NON deve contenere NGINX**
- [ ] Espone porta **3306**
- [ ] Ha uno script di inizializzazione database
- [ ] **NO daemon mode** (mysqld in foreground)

## 🔐 SICUREZZA E CREDENZIALI

- [ ] **NESSUNA PASSWORD hardcoded** nei Dockerfile
- [ ] **NESSUNA PASSWORD hardcoded** nei file di configurazione
- [ ] Le password sono gestite tramite:
  - [ ] Docker secrets, OPPURE
  - [ ] Variabili d'ambiente dal file `.env`
- [ ] Il file `.env` è presente in `.gitignore`
- [ ] File di secrets (se usati) sono in `.gitignore`
- [ ] Script di setup per generare password automaticamente (opzionale ma consigliato) -->
<!-- 
## 📦 DOCKER COMPOSE

- [ ] File `docker-compose.yml` presente nella root
- [ ] **Versione specificata** (3.8 o superiore raccomandata)
- [ ] Definisce esattamente **3 services**: nginx, wordpress, mariadb
- [ ] Ogni servizio usa `build:` (non `image:` per servizi pre-fatti)
- [ ] **Networks**: definita una rete custom (es: `inception`)
- [ ] **Volumes**: definiti almeno 2 volumi per persistenza dati:
  - [ ] Volume per database MariaDB
  - [ ] Volume per file WordPress
- [ ] Volumi montati in `/home/<user>/data/` sul host
- [ ] **depends_on**: WordPress dipende da MariaDB, NGINX dipende da WordPress
- [ ] **restart policy**: `unless-stopped` o `always` per tutti i container
- [ ] Variabili d'ambiente caricate dal file `.env` -->

<!-- ## 🌐 NETWORKING

- [ ] Creata una **docker-network custom** (non default bridge)
- [ ] Tutti i container sono sulla stessa rete
- [ ] I container comunicano tra loro tramite **service name** (es: `mariadb:3306`)
- [ ] Solo NGINX espone porte verso l'esterno (443, 80)
- [ ] WordPress e MariaDB **NON espongono porte** verso l'host (solo interne)

## 💾 VOLUMES

- [ ] **2 volumi** definiti nel docker-compose:
  - [ ] Volume per WordPress files (`/var/www/html`)
  - [ ] Volume per MariaDB data (`/var/lib/mysql`)
- [ ] I volumi sono montati in `/home/<user>/data/` sul sistema host
- [ ] Le directory sul host devono essere create prima del lancio
- [ ] Permessi corretti sulle directory:
  - [ ] MariaDB: proprietario `999:999` o `mysql:mysql`
  - [ ] WordPress: proprietario `33:33` o `www-data:www-data` -->

<!-- ## 🔧 NGINX CONFIGURATION

- [ ] File di configurazione custom in `srcs/requirements/nginx/conf/`
- [ ] Configurato come **reverse proxy** per WordPress
- [ ] Supporta **solo TLSv1.2 e/o TLSv1.3**
- [ ] Certificato SSL configurato (self-signed va bene)
- [ ] FastCGI configurato per comunicare con WordPress container
- [ ] Le richieste PHP sono inoltrate a `wordpress:9000`
- [ ] `server_name` corrisponde al `DOMAIN_NAME` del .env -->

<!-- ## 📝 WORDPRESS CONFIGURATION

- [ ] WordPress installato e configurato automaticamente allo startup
- [ ] File `wp-config.php` creato dinamicamente (non hardcoded)
- [ ] Configurato per connettersi a MariaDB tramite service name
- [ ] Credenziali database prese da variabili d'ambiente/secrets
- [ ] **2 utenti WordPress** creati:
  - [ ] 1 utente amministratore
  - [ ] 1 utente standard (non admin)
- [ ] I nomi utente **NON devono** contenere "admin", "Admin", "administrator" -->

<!-- ## 🗄️ MARIADB CONFIGURATION

- [ ] Database creato automaticamente allo startup
- [ ] Utente WordPress creato con privilegi corretti
- [ ] Password root impostata
- [ ] MariaDB accetta connessioni dalla rete Docker
- [ ] File di configurazione custom (bind-address, port, etc.) -->
- [ ] Database persiste nel volume anche dopo `docker-compose down`

<!-- ## 🛠️ MAKEFILE

- [ ] Makefile presente nella root del progetto
- [ ] Target **obbligatori**:
  - [ ] `all`: avvia il progetto completo
  - [ ] `up`: build e avvio dei container
  - [ ] `down`: stop e rimozione container
  - [ ] `clean`: pulizia completa (container, volumi, immagini)
  - [ ] `re`: fclean + up
- [ ] Il Makefile utilizza `docker-compose`
- [ ] Non devono esserci errori durante l'esecuzione
- [ ] `.PHONY` dichiarato correttamente -->

## 📚 DOCUMENTAZIONE (OBBLIGATORIA Chapter VII)

### USER_DOC.md
- [ ] File presente nella root: `USER_DOC.md`
- [ ] Scritto in formato Markdown
- [ ] Spiega i servizi forniti dallo stack
- [ ] Spiega come avviare/fermare il progetto
- [ ] Spiega come accedere al sito web
- [ ] Spiega come accedere al pannello amministrazione
- [ ] Spiega dove trovare e come gestire le credenziali
- [ ] Spiega come verificare che i servizi siano attivi

### DEV_DOC.md
- [ ] File presente nella root: `DEV_DOC.md`
- [ ] Scritto in formato Markdown
- [ ] Spiega come configurare l'ambiente da zero
- [ ] Spiega prerequisiti (Docker, Docker Compose, etc.)
- [ ] Spiega come configurare file .env e secrets
- [ ] Spiega come usare Makefile e Docker Compose
- [ ] Comandi per gestire container e volumi
- [ ] Spiega dove sono persistiti i dati
- [ ] Architettura del progetto

## 🧪 TEST FUNZIONALI

### Avvio Progetto
- [ ] `make` avvia tutto senza errori
- [ ] Tutti i container si avviano correttamente (docker ps --> up &&(healty ))
- [ ] Non ci sono errori nei log (`docker-compose logs`)

### Accesso Servizi
- [ ] Il sito è accessibile via HTTPS: `https://<DOMAIN_NAME>`
- [ ] Il certificato SSL funziona (anche se self-signed)
- [ ] WordPress è raggiungibile e completamente configurato
- [ ] Pannello admin WordPress accessibile: `https://<DOMAIN_NAME>/wp-admin`
- [ ] È possibile fare login con entrambi gli utenti creati

### Persistenza Dati
- [ ] Dopo `docker-compose down` e `docker-compose up`, i dati persistono
- [ ] Post/pagine WordPress rimangono dopo restart
- [ ] Database MariaDB mantiene i dati

### Container Restart
- [ ] I container si riavviano automaticamente in caso di crash
- [ ] Testare: `docker stop <container>` → deve ripartire

### Network
- [ ] Verificare che i container comunichino:
  ```bash
  docker exec wordpress ping mariadb
  ```

## 🚫 COSA NON DEVE ESSERCI

- [ ] ❌ NO `network: host`
- [ ] ❌ NO `--link` (deprecato)
- [ ] ❌ NO password in chiaro nei file committati
- [ ] ❌ NO immagini DockerHub già pronte (wordpress:latest, etc.)
- [ ] ❌ NO tag `latest` nei FROM dei Dockerfile
- [ ] ❌ NO infinite loop o hacky solutions (tail -f, sleep infinity)
- [ ] ❌ NO nginx dentro al container WordPress
- [ ] ❌ NO username "admin" per WordPress
- [ ] ❌ NO daemon mode nei processi principali

## 📋 CONSEGNA FINALE

- [ ] Tutti i file sono committati su Git (tranne .env e secrets)
- [ ] `.gitignore` configurato correttamente
- [ ] README.md presente e completo (opzionale ma consigliato)
- [ ] USER_DOC.md completo e chiaro
- [ ] DEV_DOC.md completo e chiaro
- [ ] Il dominio è configurato come `<login>.42.fr` (es: `giuliaviga.42.fr`)
- [ ] Aggiungere il dominio in `/etc/hosts`:
  ```
  127.0.0.1 giuliaviga.42.fr
  ```

## ✅ VERIFICA FINALE

Esegui questi comandi per un test completo:

```bash
# 1. Cleanup completo
make fclean

# 2. Verifica che tutto sia pulito
docker ps -a
docker images
docker volume ls
docker network ls

# 3. Build e avvio
make

# 4. Verifica container attivi
docker ps

# 5. Verifica logs (non devono esserci errori)
docker-compose logs

# 6. Verifica network
docker network inspect inception

# 7. Verifica volumi
docker volume ls

# 8. Testa il sito
curl -k https://giuliaviga.42.fr  # oppure il tuo dominio

# 9. Apri browser
# https://giuliaviga.42.fr
# https://giuliaviga.42.fr/wp-admin

# 10. Test persistenza
docker-compose down
docker-compose up -d
# Verifica che i dati siano ancora presenti
```

---

## 🎯 CHECKLIST RAPIDA PRE-CONSEGNA

✅ 3 container (NGINX, WordPress, MariaDB)  
✅ Dockerfile custom per ogni servizio  
✅ docker-compose.yml configurato  
✅ 2 volumi per persistenza  
✅ 1 network custom  
✅ TLS/SSL su NGINX (solo v1.2/1.3)  
✅ Nessuna password hardcoded  
✅ Makefile funzionante  
✅ **USER_DOC.md completo** ⚠️ **OBBLIGATORIO**  
✅ **DEV_DOC.md completo** ⚠️ **OBBLIGATORIO**  
✅ Dominio `<login>.42.fr` in /etc/hosts  
✅ Container riavviano automaticamente  
✅ Tutto funziona dopo `make fclean && make`  

---

**⚠️ IMPORTANTE**: Se anche solo UNO dei punti della parte mandatory non è perfetto, la parte bonus NON verrà valutata!
