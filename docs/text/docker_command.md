```
1. Создать базу Redash (только при первом запуске)
docker compose run --rm redash create_db

2. Поднять всё
docker compose up -d

3. Создаём папку внутри контейнера
docker compose exec clickhouse mkdir -p /var/lib/clickhouse/user_files/data

4. Копируем все csv внутрь контейнера
docker cp tables/. clickhouse:/var/lib/clickhouse/user_files/data/

5. Зоходим в оболочку clickhouse
docker compose exec clickhouse clickhouse-client
```