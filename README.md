# services

- MySQL
- Adminer
- Mailhog

Start all services
```shell
docker compose up -d
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
