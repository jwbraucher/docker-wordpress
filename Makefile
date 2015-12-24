# project settings
PROJECT=docker-php
OWNER=jwbraucher
MACHINE=DEV
SHELL=/bin/bash

default: build

build:
	docker build -t $(OWNER)/$(PROJECT) .

rebuild:
	docker build -t $(OWNER)/$(PROJECT) --no-cache .

clean:
	-docker-compose rm -f
	-docker rmi -f $(OWNER)/$(PROJECT)
	$(eval CONTAINERS := $(shell docker ps -a -q --filter='status=exited') )
	$(foreach container, $(CONTAINERS), docker rm $(container);)
	$(eval IMAGES := $(shell docker images | grep '^<none>' | awk '{print $$3}' ))
	$(foreach image, $(IMAGES), docker rmi $(image);)

start:
	docker-compose up -d $(PROJECT)

stop:
	$(eval CONTAINERS := $(shell docker ps -q) )
	$(foreach container, $(CONTAINERS), docker stop $(container);)

net:
	@printf "IP: "
	@docker-machine ip $(MACHINE)
	$(eval CONTAINERS := $(shell docker ps -q) )
	@printf "Ports: "
	$(foreach container, $(CONTAINERS), \
          @docker inspect \
            --format '{{ .Config.ExposedPorts }}' $(container) | \
          sed 's,[^0-9 ],,g' \
        ;)
	@echo

status:
	docker ps

cli:
	$(eval CONTAINER := $(shell docker-compose ps -q $(PROJECT) ) )
	docker exec -it $(CONTAINER) $(SHELL)

bootcli:
	docker run -it --entrypoint=$(SHELL) $(OWNER)/$(PROJECT)

env:
	docker-machine env $(MACHINE)
	@docker-machine env $(MACHINE) | tail -1 | sed 's,^# ,,' | pbcopy

.PHONY: default build clean start stop status cli
