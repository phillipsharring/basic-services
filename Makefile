.PHONY: help build build-clean start stop down db-import db-dump

include .env
export

DB_CONTAINER_NAME=db

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build: ## Builds all the images.
	@echo "Building..."
	@docker compose build
	@echo "Done!"

build-clean: ## Builds all the images, without cache.
	@echo "Building (no cache)..."
	@docker compose build --no-cache
	@echo "Done!"

start: ## Starts the basic containers, including the DB, private app, auth server, bBackend & local reverse proxy.
	@echo "Starting all containers..."; \
	docker compose up -d; \
	echo "All containers started."; \

stop: ## Stops whatever containers are running.
	@echo "Stopping all containers (this takes a couple of seconds)..."; \
	docker compose --profile webdb --profile memcache --profile redis stop; \
	echo "All containers stopped.";

down: ## Removes the containers. Does not remove the images.
	@echo "Stopping and removing all containers... (this takes a couple of seconds)"; \
	docker compose down; \
	echo "All containers stopped and removed.";

db-import: ## Imports a database file. Usage:  make db-import FILE=your_sql_file.sql [DB_NAME=your_database]. Optionally add DB_NAME to specify a database other than abre_db. To import from the ./dumps directory, you need to specify that in the FILE path. This is done for terminal autocompletion.
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make db-import FILE=your_file.sql [DB_NAME=your_db]"; \
	else \
		FILE="$(FILE)"; \
		DB_NAME="$(if $(DB_NAME),$(DB_NAME),abre_db)"; \
		mkdir -p dumps; \
		docker-compose exec -T $(DB_CONTAINER_NAME) mysql -uroot -p$(DB_PASSWORD) $$DB_NAME < $$FILE; \
	fi

db-dump: ## Dumps a database to a SQL file. Usage:  make db-dump [DB_NAME=your_database]. The file name is automatic in the form of dump_{ database name }_{ YYYYMMDDHHmm }.sql. The file is put into the ./dumps directory. Optionally add DB_NAME to specify a database other than abre_db.
	@DB_NAME=$${DB_NAME:-abre_db}; \
	mkdir -p dumps; \
	docker-compose exec $(DB_CONTAINER_NAME) mysqldump -uroot -p$(DB_PASSWORD) $$DB_NAME > dumps/dump_$$DB_NAME\_$$(date +%Y%m%d%H%M).sql
