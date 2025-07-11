# Basic Services

A Docker Compose project that sets up the following services, for use with your other local projects.

- MySQL
- Adminer
- Mailhog

## Setup

Configure this project by copying the `.env.example` to `.env` and edit the 2 values for `DB_NAME` and `DB_PASSWORD`.

## Usage
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

### Start all services
```shell
make start
```

### DB Import
```shell
make db-import FILE=sql-file.sql DB_NAME=db_name
```

### DB Export
```shell
make db-dump DB_NAME=db_name
```
