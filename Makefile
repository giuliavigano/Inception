# verifica che esistano i secrets!
check-secrets:
	@if [ ! -d ../secrets ]; then \
		chmod +x setup-secrets.sh; \
		./setup-secrets.sh; \
	fi

setup:
	mkdir -p /home/giuliaviga/data/mariadb
	mkdir -p /home/giuliaviga/data/wordpress

	sudo chown -R 999:999 /home/giuliaviga/data/mariadb
	sudo chown -R 33:33 /home/giuliaviga/data/wordpress
	
	sudo chmod 755 /home/giuliaviga/data/mariadb
	sudo chmod 755 /home/giuliaviga/data/wordpress


up: check-secrets setup
	docker-compose up --build

down:
	docker-compose down

clean:
	docker-compose down -v

fclean:
	docker-compose down -v -rmi all
	sudo rm -rf /home/giuliaviga/data/mariadb
	sudo rm -rf /home/giuliaviga/data/wordpress

logs:
	docker-compose logs -f

.PHONY: setup up check-secrets down clean fclean logs