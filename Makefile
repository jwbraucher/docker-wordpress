# Configuration
export
SHELL := /bin/bash

# Environment
image := $(shell find * -name Dockerfile -exec dirname {} \;)
ip := $(shell docker-machine ip $(USER) 2>/dev/null)
containers := $(shell docker ps -q 2>/dev/null)

# Recipes
default: $(image)

# Local Project Makefile
include Makefile.local

# Build the images (default behavior)
.PHONY: $(image)
rebuild $(image):
	@\
nocache=`echo $@ | awk '/rebuild/ {printf "--no-cache"}'` ; \
export tag=$(app) ; \
if [ "$${i}" != "$(app)" ]; then \
  tag="$(app)-$${i}"; \
fi; \
for i in $(image); do \
  cd $${i} ; \
  set -x ; \
  docker build \
    --force-rm=true \
    $${nocache} \
    -t $${i} . \
    || exit $$? ; \
  set +x ; \
  cd .. ; \
done

.PHONY: clean clean-containers clean-images clean-files
clean: clean-containers clean-images clean-files

clean-containers:
	@echo "...Cleaning Containers..."
	-command=$@ docker-compose rm -f -v $(image)
	$(eval containers := $(shell docker ps -a -q --filter='status=exited') )
	-@for container in ${containers}; do docker rm $${container}; done

clean-images:
	@echo "...Cleaning Images..."
	$(eval images := $(shell docker images | grep '^<none>' | awk '{print $$3}' ))
	-@for i in ${images}; do docker rmi $${i}; done

clean-files:
	@echo "...Cleaning Untracked Files (Git)..."
	-git clean -xdf

.PHONY: start install
start install:
	command=$@ docker-compose up -d $(service)

.PHONY: stop
stop:
	command=$@ docker-compose stop $(service)

.PHONY: restart
restart: stop start

.PHONY: status
status:
	docker ps

.PHONY: logs
logs:
	$(eval container := $(shell command=$@ app=${app} ip=${ip} docker-compose ps -q $(service) | head -1) )
	docker logs -f $(container)

.PHONY: cli
cli:
	$(eval container := $(shell command=$@ app=${app} ip=${ip} docker-compose ps -q $(service) | head -1) )
	docker exec -it $(container) /bin/bash -o vi

.PHONY: start-cli
start-cli:
	command=$@ docker-compose run --rm --entrypoint /bin/bash $(service) -o vi

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
	$(eval PORTS := $(shell for container in ${containers}; do \
          docker inspect \
            --format '{{ .Config.ExposedPorts }}' $${container} | \
	    sed 's,[^0-9 ],,g' ; \
	  done ) )
	@for port in ${PORTS} ; do printf "${ip}:$${port}\n"; done
