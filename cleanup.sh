docker-compose --env-file srcs/.env down -v
docker ps -a
docker rm -f mariadb wordpress 2>/dev/null || true
docker ps -a | grep -E "mariadb|wordpress"
docker volume rm inception_mariadb_data 2>/dev/null || true
docker volume rm inception_wordpress_data 2>/dev/null || true
docker volume rm srcs_mariadb_data 2>/dev/null || true
docker volume rm srcs_wordpress_data 2>/dev/null || true
docker volume ls | grep -E "mariadb|wordpress"
docker rmi inception_mariadb 2>/dev/null || true
docker rmi inception_wordpress 2>/dev/null || true
docker rmi srcs_mariadb 2>/dev/null || true
docker rmi srcs_wordpress 2>/dev/null || true
docker images | grep -E "inception|srcs"
docker network rm inception 2>/dev/null || true
docker network ls | grep inception
sudo rm -rf /home/giuliaviga/data/mariadb
sudo rm -rf /home/giuliaviga/data/wordpress
ls -la /home/giuliaviga/data/
docker system prune -a --volumes -f

echo "=== Verifica Container ==="
docker ps -a | grep -E "mariadb|wordpress" || echo "✓ Nessun container"

echo "=== Verifica Volumi ==="
docker volume ls | grep -E "mariadb|wordpress" || echo "✓ Nessun volume"

echo "=== Verifica Immagini ==="
docker images | grep -E "inception|srcs" || echo "✓ Nessuna immagine"

echo "=== Verifica Rete ==="
docker network ls | grep inception || echo "✓ Nessuna rete"

echo "=== Verifica Directory ==="
ls -la /home/giuliaviga/data/mariadb 2>/dev/null || echo "✓ Directory non esistente"

echo "=== Verifica Directory ==="
ls -la /home/giuliaviga/data/wordpress 2>/dev/null || echo "✓ Directory non esistente"