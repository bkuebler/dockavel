
deploy: prepare build

deploy-dev: prepare build-dev

prepare: prepare-composer prepare-npm

prepare-composer:
	composer install

prepare-npm:
	npm install

build:
	npm run production
	docker-compose pull
	docker-compose build --pull --compress --force-rm --no-cache

build-dev:
	npm run development
	docker-compose pull
	docker-compose build --pull

clean:
	php artisan optimize:clear
	rm -rvf bootstrap/cache/* storage/logs/*

purge: clean
	rm -rvf node_modules/* vendor/* docker/volumes/db/*

run: clean deploy-dev
	docker-compose up

help:
	@echo "Possible Commands are:"
	@echo ""
	@echo "build\t\tExecutes building process for Frontend and Containers - PROD"
	@echo "build-dev\tExecutes building process for Frontend and Containers - DEV"
	@echo "clean\t\tCleanup all files generated during build and runs"
	@echo "deploy\t\tInstall all dependencies and execute build for Production (Default)"
	@echo "deploy-dev\tInstall all dependencies and execute build for Development"
	@echo "purge\t\tPurge everything, also Development persistences"
	@echo "run\t\tDeploy and Run in Development mode"
