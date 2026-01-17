setup:
	mkdir -p /home/gvigano/data/mariadb
	mkdir -p /home/gvigano/data/wordpress

up: setup
	docker-compose up -d

down:
	docker-compose down

clean:
	docker-compose down -v

fclean:
	docker-compose down -v -rmi all
	rm -f /home/gvigano/data/mariadb
	rm -f /home/gvigano/data/wordpress

logs:
	docker-compose logs -f

.PHONY: setup up down clean fclean logs