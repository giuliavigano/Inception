all: up

check-secrets:
	@if [ ! -d ./secrets ]; then \
		chmod +x ./srcs/setup-secrets.sh; \
		./srcs/setup-secrets.sh; \
	fi

setup:
	sudo mkdir -p /home/giuliaviga/data/mariadb
	sudo mkdir -p /home/giuliaviga/data/wordpress
	sudo chmod 775 /home/giuliaviga/data/mariadb
	sudo chmod 775 /home/giuliaviga/data/wordpress

build: check-secrets
	docker compose --env-file srcs/.env build

up: check-secrets setup
	docker compose --env-file srcs/.env up -d

down:
	docker compose --env-file srcs/.env down

clean:
	docker compose --env-file srcs/.env down -v

fclean:
	docker compose --env-file srcs/.env stop
	docker compose --env-file srcs/.env down -v --rmi all
	sudo rm -rf /home/giuliaviga/data/mariadb
	sudo rm -rf /home/giuliaviga/data/wordpress

logs:
	docker compose --env-file srcs/.env logs -f

re: fclean up

.PHONY: all re setup build up check-secrets down clean fclean logs