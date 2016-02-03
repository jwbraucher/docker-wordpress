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
# if "rebuild" target is added, build images with --no-cache
.PHONY: $(image)
rebuild $(image):
	@\
nocache=`echo $@ | awk '/rebuild/ {printf "--no-cache"}'` ; \
set -x ; \
command=$@ docker-compose build \
  --force-rm \
  $${nocache} \

# Clean up everything including all local images
.PHONY: distclean
distclean: stop clean
	@ set -x ; \
images=`docker images -q` ; \
for i in $${images}; do \
  docker rmi -f $${i} ; \
  done

# Image/Container/Data clean-up
.PHONY: clean clean-containers clean-images clean-files
clean: clean-containers clean-images clean-files

clean-containers:
	@echo "...Cleaning Containers..."
	-command=$@ docker-compose rm -f -v
	$(eval containers := $(shell docker ps -a -q --filter='status=exited') )
	-@for container in ${containers}; do docker rm $${container}; done

clean-images:
	@echo "...Cleaning Images..."
	$(eval images := $(shell docker images | grep '^<none>' | awk '{print $$3}' ))
	-@for i in ${images}; do docker rmi $${i}; done

clean-files:
	@echo "...Cleaning Untracked Files (Git)..." ; set -x ; \
  git ls-files --directory --others -i --exclude-standard \
  | grep -v volumes/export | xargs -t rm -rf

pull:
	@echo "...Pulling image..."
	docker pull braucher/$(app)
	command=$@ docker-compose pull

# stopped container commands
.PHONY: start install restore
start install restore:
	command=$@ docker-compose up -d $(service)

# running container commands
.PHONY: backup configure
backup configure:
	@ set -x ; \
command=$(@) ; \
container=`docker-compose ps -q $${app} 2>/dev/null` ; \
docker exec -it $${container} /app $${command}

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
	@ set -x ; \
export theservice="$${app}" ; \
if [ ! -z "$${service}" ]; then \
  theservice=$${service} ; \
fi ; \
container=`docker-compose ps -q $${theservice} 2>/dev/null` ; \
docker logs -f $${container}

.PHONY: cli
cli:
	@ set -x ; \
export theservice="$${app}" ; \
if [ ! -z "$${service}" ]; then \
  theservice=$${service} ; \
fi ; \
container=`docker-compose ps -q $${theservice} 2>/dev/null` ; \
docker exec -it $${container} /bin/bash -o vi

.PHONY: start-cli
start-cli:
	@ set -x ; \
export theservice="$${app}" ; \
if [ ! -z "$${service}" ]; then \
  theservice=$${service} ; \
fi ; \
command=$@ docker-compose run --rm --entrypoint /bin/bash $${theservice} -o vi

# manage docker machine
.PHONY: machine
machine:
	-docker-machine create --driver virtualbox $(USER)
	-docker-machine start $(USER)

.PHONY: stop-machine
machine-stop:
	docker-machine stop $(USER)

# Show environment command, and add to clipboard to setup local environment
.PHONY: env
env:
	docker-machine env $(USER)
	@-docker-machine env $(USER) | tail -1 | sed 's,^# ,,' | pbcopy

# Show network connection information for running containers
.PHONY: net
net:
	@echo "Network Configuration:"
	$(eval PORTS := $(shell for container in ${containers}; do \
          docker inspect \
            --format '{{ .Config.ExposedPorts }}' $${container} | \
	    sed 's,[^0-9 ],,g' ; \
	  done ) )
	@for port in ${PORTS} ; do printf "${ip}:$${port}\n"; done
