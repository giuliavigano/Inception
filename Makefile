all: up

check-secrets:
	@if [ ! -d ./secrets ]; then \
		chmod +x setup-secrets.sh; \
		./setup-secrets.sh; \
	fi

setup:
	sudo rm -rf /home/gvigano/data/mariadb
	sudo rm -rf /home/gvigano/data/wordpress
	mkdir -p /home/gvigano/data/mariadb
	mkdir -p /home/gvigano/data/wordpress

	sudo chown -R 999:999 /home/gvigano/data/mariadb
	sudo chown -R 33:33 /home/gvigano/data/wordpress

	sudo chmod 755 /home/gvigano/data/mariadb
	sudo chmod 755 /home/gvigano/data/wordpress

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
	sudo rm -rf /home/gvigano/data/mariadb
	sudo rm -rf /home/gvigano/data/wordpress

logs:
	docker compose --env-file srcs/.env logs -f

re: fclean up

.PHONY: all re setup build up check-secrets down clean fclean logs