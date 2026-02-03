check-secrets:
	@if [ ! -d ./secrets ]; then \
		chmod +x setup-secrets.sh; \
		./setup-secrets.sh; \
	fi

setup:
	sudo rm -rf /home/giuliaviga/data/mariadb
	sudo rm -rf /home/giuliaviga/data/wordpress
	mkdir -p /home/giuliaviga/data/mariadb
	mkdir -p /home/giuliaviga/data/wordpress

	sudo chown -R 999:999 /home/giuliaviga/data/mariadb
	sudo chown -R 33:33 /home/giuliaviga/data/wordpress

	sudo chmod 755 /home/giuliaviga/data/mariadb
	sudo chmod 755 /home/giuliaviga/data/wordpress


up: check-secrets setup
	docker-compose --env-file srcs/.env up --build --force-recreate

down:
	docker-compose --env-file srcs/.env down

clean:
	docker-compose --env-file srcs/.env down -v

fclean:
	-docker-compose --env-file srcs/.env down -v -rmi all 2>/dev/null || true
	sudo rm -rf /home/giuliaviga/data/mariadb
	sudo rm -rf /home/giuliaviga/data/wordpress

logs:
	docker-compose --env-file srcs/.env logs -f

.PHONY: setup up check-secrets down clean fclean logs