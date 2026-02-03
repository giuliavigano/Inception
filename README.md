This project has been created as partof the 42 curriculum by gvigano

## 📋 Indice

- [Descrizione](#descrizione)
- [Architettura](#architettura)
- [Installazione](#installazione)
- [Volumi](#struttura-dei-volumi)
- [Risorse](#-risorse-utilid)
- [Note](#-note-tecniche)

## 🎯 Descrizione

Inception è un progetto di system administration e infrastruttura Docker che implementa un ambiente LEMP (Linux, Nginx, MariaDB, PHP) completo utilizzando Docker Compose; con WordPress come applicazione web principale.
L'obiettivo è configurare una piccola infrastruttura composta da diversi servizi seguendo regole specifiche:

- Ogni servizio deve girare in un container Docker dedicato
- I container devono essere costruiti da immagini Docker personalizzate
- L'intera infrastruttura deve essere orchestrata con Docker Compose
- I dati devono persistere utilizzando volumi Docker

## 🏗️ Architettura

Il progetto implementa una stack LEMP completa con i seguenti componenti:

NGINX (Reverse Proxy) 		==>		WordPress + PHP-FPM 7.4		==>		MariaDB (Database Server )
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
# Sostituisci 'giuliaviga' con il tuo login 42
DOMAIN_NAME=tuologin.42.fr

WP_ADMIN_USER=tuologin
WP_ADMIN_EMAIL=tuologin@student.42.fr

# Sostituisci anche i percorsi dei volumi
WP_DATA_PATH=/home/tuologin/data/wordpress
DB_DATA_PATH=/home/tuologin/data/mariadb
```

> ⚠️ **Importante**: Le uniche modifiche necessarie sono il domain name, l'admin user/email e i percorsi dei volumi con il tuo username.

### 3. Configura il file hosts

Aggiungi il dominio al file `/etc/hosts` per testare localmente:

```bash
sudo echo "127.0.0.1 tuologin.42.fr" >> /etc/hosts
```

### 4. Controlla secrets

I secrets vengono gestiti automaticamente dal Makefile tramite lo script 'setup-secrets.shì.
Assicurati ch elo script sia eseguibile:

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
   Dovresti vedere 3 container in esecuzione: `nginx`, `wordpress`, `mariadb`

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

### Altri Comandi Utili

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

### Porte già in uso

Se le porte 80 o 443 sono occupate:
```bash
# Controlla quali processi usano le porte
sudo lsof -i :80
sudo lsof -i :443

# Ferma Apache o altri web server
sudo systemctl stop apache2
```

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

- **Immagini Docker personalizzate**: I container utilizzano Debian Bullseye come immagine base
- **Sicurezza**: 
  - Certificati SSL self-signed generati automaticamente
  - Password gestite tramite Docker secrets
  - Nessuna password hardcoded nel codice
- **Orchestrazione**: I servizi si avviano in modo sequenziale grazie agli health checks
- **Persistenza**: I dati di WordPress e MariaDB sono persistenti tramite volumi
- **Best practices**: Isolamento dei servizi, un processo per container, restart policies

### Struttura dei Volumi

- `/home/tuologin/data/wordpress` → Contiene i file di WordPress (wp-content, themes, plugins) condivisi anche ccon Nginx in :ro
- `/home/tuologin/data/mariadb` → Contiene il database MariaDB

### Secrets Generati

I secrets sono generati automaticamente con OpenSSL e salvati in `secrets/`:
- `db_root_password.txt` → Password root di MariaDB
- `db_wordpress_password.txt` → Password utente WordPress del database
- `wp_admin_password.txt` → Password amministratore WordPress
- `wp_user2_password.txt` → Password secondo utente WordPress

## 📚 Risorse Utili

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [WordPress Official Documentation](https://wordpress.org/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.org/documentation/)
- [NGINX Documentation](https://nginx.org/en/docs/)

## 👤 Autore
gvigano