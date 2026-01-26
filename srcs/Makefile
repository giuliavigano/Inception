# verifica che esistano i secrets!
check-secrets:
	@if [ ! -d ./secrets]; then \
		chmod +x setup-secrets.sh \
		./setup-secrets.sh; \
	fi

setup:
	mkdir -p /home/giuliaviga/data/mariadb
	mkdir -p /home/giuliaviga/data/wordpress

# e dove fai il build dei servizi con ("docker build" o "docker-compose up --build")
# ?????

up: check-secrets setup
	docker-compose up --build

down:
	docker-compose down

clean:
	docker-compose down -v

fclean:
	docker-compose down -v -rmi all
	sudo rm -rf /home/gvigano/data/mariadb
	sudo rm -rf /home/gvigano/data/wordpress

logs:
	docker-compose logs -f

.PHONY: setup up check-secrets down clean fclean logs