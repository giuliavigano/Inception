*This project has been created as part of the 42 curriculum by gvigano*

## 📋 Indice

- [Descrizione](#-descrizione)
- [Architettura](#️-architettura)
- [Installazione](#️-installazione)
- [Troubleshooting](#-troubleshooting)
- [Note](#-note-tecniche)
- [Design Choices]
- [Risorse](#-risorse-utilid)

## 🎯 Descrizione

Inception è un progetto di system administration e infrastruttura Docker che implementa un ambiente LEMP (Linux, Nginx, MariaDB, PHP) completo utilizzando Docker Compose; con WordPress come applicazione web principale.
L'obiettivo è configurare una piccola infrastruttura composta da diversi servizi seguendo queste richieste:

 - A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
 - A Docker container that contains WordPress + php-fpm (it must be installed and configured) only, without nginx.
 - A Docker container that contains MariaDB only, without nginx.
 - A volume that contains your WordPress database.
 - A second volume that contains your WordPress website files.
 - A docker-network that establishes the connection between your containers.
 - Your containers have to restart in case of a crash

E queste regole specifiche:
- Ogni servizio deve girare in un container Docker dedicato
- I container devono essere costruiti da immagini Docker personalizzate, implementate e non scaricate
- L'intera infrastruttura deve essere orchestrata con Docker Compose
- I dati devono persistere utilizzando volumi Docker

## 🏗️ Architettura

Il progetto implementa una stack LEMP completa con i seguenti componenti:

NGINX (Reverse Proxy) 		==>		WordPress + PHP-FPM 7.4		==>		MariaDB (Database Server)
Porte: 80 (HTTP), 443 (HTTPS)			Porta: 9000 							Porta: 3306

## ⚙️ Installazione

### Prerequisiti

Prima di iniziare, assicurati di avere installato:

- **Docker** (versione 20.10 o superiore)
  ```bash
  docker --version
  ```
- **Docker Compose** (versione 1.29 o superiore)
  ```bash
  docker-compose --version
  ```
- **Make** (per utilizzare il Makefile)
  ```bash
  make --version
  ```
- **OpenSSL** (per generare i secrets)
  ```bash
  openssl version
  ```

### 1. Clona la repository

```bash
git clone <repository-url>
cd inception
```

### 2. Personalizza la configurazione

Modifica il file `srcs/.env` con i tuoi dati:

```bash
# Sostituisci 'gvigano' con il tuo login
DOMAIN_NAME=tuologin.42.fr

WP_ADMIN_USER=tuologin
WP_ADMIN_EMAIL=tuologin@student.42.fr

# Sostituisci anche i percorsi dei volumi
WP_DATA_PATH=/home/tuologin/data/wordpress
DB_DATA_PATH=/home/tuologin/data/mariadb
```

```bash
# Sostituisci 'gvigano' con il tuo login in questi comandi nel Makefile
setup:
	sudo rm -rf /home/tuologin/data/mariadb
	sudo rm -rf /home/tuologin/data/wordpress
	mkdir -p /home/tuologin/data/mariadb
	mkdir -p /home/tuologin/data/wordpress

	sudo chown -R 999:999 /home/tuologin/data/mariadb
	sudo chown -R 33:33 /home/tuologin/data/wordpress

	sudo chmod 755 /home/tuologin/data/mariadb
	sudo chmod 755 /home/tuologin/data/wordpress

fclean:
	docker-compose --env-file srcs/.env stop
	docker-compose --env-file srcs/.env down -v --rmi all
	sudo rm -rf /home/tuologin/data/mariadb
	sudo rm -rf /home/tuologin/data/wordpress
```

```bash
# Sostituisci il domain name all'interno del file setup-ssl.sh con il tuo in questa riga di codice
-subj "/C=IT/ST=Lazio/L=Roma/O=42/CN=gvigano.42.fr"
```

> ⚠️ **Importante**: Le uniche modifiche necessarie sono il domain name, l'admin user/email e i percorsi dei volumi con il tuo username.

### 3. Configura il file hosts

Aggiungi il dominio al file `/etc/hosts` per testare localmente:

```bash
echo "127.0.0.1 tuologin.42.fr" | sudo tee -a /etc/hosts
```

Questo comando mappa il dominio `tuologin.42.fr` all'indirizzo locale `127.0.0.1`, permettendo al browser di risolvere il dominio senza DNS pubblico.

### 4. Controlla secrets

I secrets vengono gestiti automaticamente dal Makefile tramite lo script 'setup-secrets.sh'.
Assicurati che lo script sia eseguibile:

```bash
chmod +x setup-secrets.sh
```

### 5. Avvia l'infrastruttura

```bash
make up
```

Questo comando:
- Genera automaticamente i secrets se non esistono
- Crea le directory per i volumi
- Configura i permessi corretti
- Avvia tutti i container con Docker Compose

### 6. Verifica l'installazione

Attendi che tutti i servizi si avviino (circa 1-2 minuti) e verifica:

1. **Controlla lo stato dei container:**
   ```bash
   docker ps
   ```
   Dovresti vedere 3 container in esecuzione e con stato (healthy): `nginx`, `wordpress`, `mariadb`

2. **Visualizza i logs:**
   ```bash
   make logs
   ```

3. **Accedi al sito WordPress:**
   - Apri il browser e vai su: `https://tuologin.42.fr`
   - Accetta il certificato SSL self-signed
   - Dovresti vedere la homepage di WordPress

4. **Accedi alla dashboard admin:**
   - URL: `https://tuologin.42.fr/wp-admin`
   - Username: quello configurato in `WP_ADMIN_USER`
   - Password: contenuta in `secrets/wp_admin_password.txt`

### Altri comandi Make utili

```bash
# Ferma i container senza rimuovere i volumi
make down

# Ferma i container e rimuove i volumi
make clean

# Rimuove tutto (container, volumi, immagini)
make fclean

# Visualizza i logs in tempo reale
make logs
```

## 🔧 Troubleshooting

### Problemi di permessi

Se riscontri errori di permessi sui volumi:
```bash
# Riavvia con make fclean e poi make up
make fclean
make up
```

### I container non si avviano

```bash
# Controlla i logs per vedere gli errori
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Reset completo

Per ricominciare da zero:

```bash
make fclean
rm -rf secrets/
make up
```

## 📝 Note Tecniche

Questo progetto è stato sviluppato come parte del curriculum di 42.

### Caratteristiche Implementate

- **Immagini Docker personalizzate**: I container utilizzano Debian Bullseye solo come immagine base
- **Sicurezza**: 
  - Certificati SSL self-signed generati automaticamente
  - Password gestite tramite Docker secrets e generate randomicamente con openssl, nessuna password hardcoded nel codice
- **Orchestrazione**: I servizi si avviano in modo sequenziale grazie agli health checks e depend_on (prima mariadb poi wordpress e infine Nginx)
- **Persistenza**: I dati di WordPress e MariaDB sono persistenti tramite volumi
- **Best practices**: 
  - Isolamento dei servizi: ogni container esegue un singolo processo principale
  - Gestione PID 1: i processi principali (nginx, php-fpm, mysqld) vengono eseguiti in foreground come PID 1 per gestire correttamente i segnali di sistema (SIGTERM, SIGINT)
  - Restart policy `unless-stopped`: i container si riavviano automaticamente in caso di crash ma possono essere fermati manualmente
  - Network isolation: comunicazione tra container tramite rete dedicata `inception`

### Struttura dei Volumi

- `/home/tuologin/data/wordpress` → Contiene i file di WordPress (wp-content, themes, plugins) condivisi anche con Nginx in :ro per reverse proxy
- `/home/tuologin/data/mariadb` → Contiene il database MariaDB

### Secrets Generati

I secrets sono generati automaticamente con OpenSSL e salvati in `secrets/`:
- `db_root_password.txt` → Password root di MariaDB
- `db_wordpress_password.txt` → Password utente WordPress del database
- `wp_admin_password.txt` → Password amministratore WordPress
- `wp_user2_password.txt` → Password secondo utente WordPress

## 🔈Design Choices

### Virtual Machine Vs Docker
- **Virtual Machine**: Ha RAM, disco, OS dedicati --> include un intero OS guest + hypervisor (PESANTE, GB di RAM, minuti per boot)

- **Docker**: Conidivide il Kernel Linux dell'host --> include solo l'applicazione e le sue dipendenze (MB, secondi per l'avvio)

- **Isolamento**: VM = isolamento hardware completo (molto sicuro), Docker = isolamento a livello di processo

- **Portabilità**: Docker Container sono portabili

- **Quando usa l'uno o l'altro**: VM per isolamento totale/sicurezza critica, Docker per microservizi/sviluppo/deployment rapido

### Secrets Vs Environment Variables
- **Secrets**:
	- Montati come file in /run/secrets/<secret_name>, temporary files in RAM cancellati allo stop.
	- Non appaiono in docker history
	- Solo container autoizzati vi hanno accesso

- **Env vars**:
	- Visisbili con 'docker inspect'
	- Salvate nel layer dell'immagine
	- Visibili nei log (se stampate)
	- Appaiono in docker history
	- Vi ha accesso chiunque abbia accesso al container

**Best Practice**:
- Secrets per password/chiavi API
- Env vars per configurazioni non sensibili

### Docker Network Vs Host Network
- **Docker Network**:
	- Rete isolata con subnet privato
	- DNS interno automatico (risolve nomi servizi)
	- Porte non esposte all'host, solo esplicitamente nel caso
	- **sicurezza** Container non raggiungibili dall'esterno

- **Host Network**:
	- Container usa direttamente la rete dell'host
	- Performance migliori ma **zero isolamento**

**Docker Network** per: isolamento, gestione DNS, possibilità di avere piu reti separate

### Docker Volumes Vs Bind Mounts
- **Docker Volumes**:
	- Creati da Docker in /var/lib/docker/volumes/
	- Gestiti completamente da Docker
	- Comandi disponibili: *docker volume create*, *docker volume ls*, *docker volume rm*
	- Non devi preoccuparti di permessi/ownership
- **Bind Mounts**:
	- *Path assoluto* dell'host montato nel container
	- Devi gestire tu: permessi/ownership/backup
	- Utile per sviluppo, modifihe immediate
	- *Problema*: dipendenza dal filesystem dell'host

**Bind Mounts** richiesto per questo progetto 

## 📚 Risorse Utili

- [Docker Documentation](https://docs.docker.com/)
- [Docker Video](https://www.youtube.com/watch?v=3c-iBn73dDE&t=117ss)
- [WordPress Official Documentation](https://wordpress.org/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.org/documentation/)
- [NGINX Documentation](https://nginx.org/en/docs/)

L'uso dell'AI (Claude Sonnet 4.5) in questo progetto si è limitato a domande teoriche, più che altro descrizione dei miei ragionamenti e collegamenti acquisiti e controllo della loro validità teorica (tenendo conto che più andavo avanti nello studio più scoprivo cose nuove ho preferito cercare in qualche modo di correggere i miei ragionamenti il prima possibile e passo passo, quando non avevo possibilità di farlo con un compagno/a a scuola). Per la validità mi è servito molto questionare anche i concetti teorici nuovi (o perlomeno la spiegazione fornita dall'AI), per una mia completa comprensione prima di lavorare sulla sua implementazione pratica.

L'uso dell'AI (Claude Sonnet 4.5) mi ha anche aiutato nell'implementazione di questo file per quanto riguarda la sintassi Markdown, ad esempio per formattare correttamente i blocchi di codice con syntax highlighting bash, quindi nello studio della corretta sintassi.