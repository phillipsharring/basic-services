# services

- MySQL
- Adminer
- Mailhog

Start all services
```shell
make start
```
DB Import
```shell
make db-import FILE=sql-file.sql DB_NAME=db_name
```
DB Export
```shell
make db-dump DB_NAME=db_name
```
Configure other docker compose files to use this network
```yml
services:
  some-service:
    networks:
      - services_default

# later
networks:
  services_default:
    external: true
```
