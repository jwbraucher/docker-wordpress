# project settings
PROJECT=docker-image
OWNER=jwbraucher
MACHINE=DEV
SHELL=/bin/bash

default: build

build:
	@docker build -t $(OWNER)/$(PROJECT) .

rebuild:
	@docker build -t $(OWNER)/$(PROJECT) --no-cache . 

clean:
	@docker rmi $(OWNER)/$(PROJECT)

clean-images:
	@docker run -ti \
          -v /var/run/docker.sock:/var/run/docker.sock \
          yelp/docker-custodian dcgc --exclude-image yelp/docker-custodian:latest \
          --max-container-age 0minutes --max-image-age 0minutes

start:
	@docker start $(OWNER)/$(PROJECT)

stop:
	@docker stop $(OWNER)/$(PROJECT)

status:
	@docker inspect $(OWNER)/$(PROJECT)

cli:
	@docker exec -it $(OWNER)/$(PROJECT) $(SHELL)

bootcli:
	@docker run -it --entrypoint=$(SHELL) $(OWNER)/$(PROJECT)

env:
	@docker-machine env $(MACHINE)
	@docker-machine env $(MACHINE) | tail -1 | sed 's,^# ,,' | pbcopy

.PHONY: default build clean start stop status cli
