
# makefile constants
IMAGE=app
MACHINE=DEV
SHELL=/bin/bash

# shell environment variables
export MYSQL_ROOT_PASSWORD=password

# facts
CONTAINER := $(shell docker-compose ps -q $(IMAGE) 2>/dev/null )
CURRENT_DIRECTORY := $(shell pwd)

default: build

build:
	@docker-compose build $(IMAGE)

rebuild:
	@docker-compose build --no-cache $(IMAGE)

clean:
	@docker-compose rm --force $(IMAGE)
	@docker run -ti \
          -v /var/run/docker.sock:/var/run/docker.sock \
          yelp/docker-custodian dcgc --exclude-image yelp/docker-custodian:latest \
          --max-container-age 0minutes --max-image-age 0minutes

start:
	@docker-compose up -d

stop:
	@docker-compose stop

status:
	@docker-compose ps

cli:
	@docker exec -it $(CONTAINER) $(SHELL)

env:
	@docker-machine env $(MACHINE)
	@docker-machine env $(MACHINE) | tail -1 | sed 's,^# ,,' | pbcopy

.PHONY: default build clean start stop status cli
