CONTAINER?=$(shell basename $(CURDIR))_php_1
BUILDCHAIN?=$(shell basename $(CURDIR))_webpack_1

.PHONY: build clean composer dev npm up

build: up
	docker exec -it ${BUILDCHAIN} npm run build
clean:
	docker-compose down -v
	docker-compose up --build
composer: up
	docker exec -it ${CONTAINER} composer \
		$(filter-out $@,$(MAKECMDGOALS))
craft: up
	docker exec -it ${CONTAINER} php craft \
		$(filter-out $@,$(MAKECMDGOALS))
dev: up
npm: up
	docker exec -it ${BUILDCHAIN} npm \
		$(filter-out $@,$(MAKECMDGOALS))
update:
	docker-compose down
	rm -f cms/composer.lock
	rm -f buildchain/package-lock.json
	docker-compose up
update-clean:
	docker-compose down
	rm -f cms/composer.lock
	rm -rf cms/vendor/
	rm -f buildchain/package-lock.json
	rm -rf buildchain/node_modules/
	docker-compose up
up:
	if [ ! "$$(docker ps -q -f name=${CONTAINER})" ]; then \
		cp -n cms/example.env cms/.env; \
		docker-compose up; \
    fi
%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
