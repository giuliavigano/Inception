This project has been created as partof the 42 curriculum by gvigano

## 📋 Indice

- [Descrizione](#descrizione)
- [Architettura](#architettura)
- [Installazione](#installazione)

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

```bash
git clone <repository-url>
cd inception