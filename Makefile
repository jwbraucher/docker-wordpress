# Configuration
export
SHELL := /bin/bash

# Environment
IMAGE:=$(shell find * -name Dockerfile -exec dirname {} \;)
IP := $(shell docker-machine ip $(USER) 2>/dev/null)
CONTAINERS := $(shell docker ps -q 2>/dev/null)

# Recipes
default: $(IMAGE)

# Local Project
include Makefile.local

.PHONY: $(IMAGE)
$(IMAGE):
	@for i in $(IMAGE); do \
	  docker build --force-rm=true -t $${i} -f $${i}/Dockerfile . \
	  || exit $$? ; \
	  done

.PHONY: rebuild
rebuild:
	@for i in $(IMAGE); do \
	  docker build --force-rm=true -t $${i} -f $${i}/Dockerfile --no-cache . \
	  || exit $$? ; \
	  done

.PHONY: clean clean-containers clean-images clean-files
clean: clean-containers clean-images clean-files

clean-containers:
	@echo "...Cleaning Containers..."
	-docker-compose rm -f -v $(IMAGE)
	$(eval CONTAINERS := $(shell docker ps -a -q --filter='status=exited') )
	-@for container in ${CONTAINERS}; do docker rm $${container}; done

clean-images:
	@echo "...Cleaning Images..."
	$(eval IMAGES := $(shell docker images | grep '^<none>' | awk '{print $$3}' ))
	-@for i in ${IMAGES}; do docker rmi $${i}; done

clean-files:
	@echo "...Cleaning Untracked Files (Git)..."
	-git clean -xdf

.PHONY: start install
start install:
	command=$@ docker-compose up -d $(SERVICE)

.PHONY: stop
stop:
	command=$@ docker-compose stop $(SERVICE)

.PHONY: restart
restart: stop start

.PHONY: status
status:
	docker ps

.PHONY: logs
logs:
	$(eval CONTAINER := $(shell docker-compose ps -q $(SERVICE) | head -1) )
	docker logs -f $(CONTAINER)

.PHONY: cli
cli:
	$(eval CONTAINER := $(shell docker-compose ps -q $(SERVICE) | head -1) )
	docker exec -it $(CONTAINER) /bin/bash -o vi

.PHONY: start-cli
start-cli:
	command=$@ docker-compose run --rm --entrypoint /bin/bash $(SERVICE) -o vi

.PHONY: machine
machine:
	-docker-machine create --driver virtualbox $(USER)
	-docker-machine start $(USER)

.PHONY: stop-machine
machine-stop:
	docker-machine stop $(USER)

.PHONY: env
env:
	docker-machine env $(USER)
	@-docker-machine env $(USER) | tail -1 | sed 's,^# ,,' | pbcopy

.PHONY: net
net:
	@echo "Network Configuration:"
	$(eval PORTS := $(shell for container in ${CONTAINERS}; do \
          docker inspect \
            --format '{{ .Config.ExposedPorts }}' $${container} | \
	    sed 's,[^0-9 ],,g' ; \
	  done ) )
	@for port in ${PORTS} ; do printf "${IP}:$${port}\n"; done
