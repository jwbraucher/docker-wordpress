# Configuration
export
SHELL := /bin/bash
ip := 0.0.0.0
command := default

# Recipes

# Local Project Makefile
include Makefile.local

### Build Commands

# Build the images (default behavior)
# if "rebuild" target is added, build images with --no-cache
image := $(shell find * -name Dockerfile -exec dirname {} \;)
default: $(image)
.PHONY: $(image)
rebuild $(image):
	@ \
nocache=`echo $@ | awk '/rebuild/ {printf "--no-cache"}'` ; \
set -x ; \
docker-compose build --force-rm $${nocache} 

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
	@echo "...Cleaning Containers..." ; set -x ; \
docker-compose rm -f -v ; \
containers=`docker ps -a -q --filter='status=exited'` ; \
for container in $${containers}; do docker rm $${container}; done

clean-images:
	@echo "...Cleaning Images..." ; set -x ; \
images=`docker images | grep '^<none>' | awk '{print $$3}'` ; \
for i in $${images}; do docker rmi $${i}; done

clean-files:
	@echo "...Cleaning Files..." ; set -x ;\
find volumes/ \
-type d -name export -prune -o \
-type f -exec rm -f {} \; ; \
find volumes/ -mindepth 1 -type d -empty -delete

pull:
	@echo "...Pulling images..." ; \
docker-compose pull ; \
images=`find . -name Dockerfile -exec grep ^FROM {} \; | awk '{print $$2}'` ; \
for i in $${images}; do \
  docker pull $${i} ; \
done

release:
	@echo "...Pushing new release..." ; set -ex ; \
version=`cat VERSION` ; \
git checkout master ; git tag $${version} ; git push origin $${version} ; \
git checkout latest ; git merge master ; git push origin latest ; \
git checkout master ; 

### Container Commands

# stopped container commands
.PHONY: start install restore
start install restore:
	@ set -x ; \
export ip=`docker-machine ip $${USER} 2>/dev/null` ; \
export command=$@ ; \
docker-compose up -d $${service}

# running container commands
.PHONY: backup configure
backup configure:
	@ set -x ; \
container=`docker-compose ps -q $${app} 2>/dev/null` ; \
docker exec -it $${container} /app $${command}

.PHONY: stop
stop:
	docker-compose stop $(service)

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

### Docker Machine commands

# manage docker machine
.PHONY: machine
machine:
	@- set -x ; \
docker-machine create --driver virtualbox $(USER) ; \
docker-machine start $(USER)

.PHONY: stop-machine
machine-stop:
	docker-machine stop $(USER)

# Show environment command, and add to clipboard to setup local environment
.PHONY: env
env:
	@- docker-machine env $(USER) ; \
  docker-machine env $(USER) | \
  tail -1 | sed 's,^# ,,' | pbcopy

# Show network connection information for running containers
.PHONY: net
net:
	@echo "Network Configuration:" ; \
containers=`docker ps -q 2>/dev/null` ; \
ip=`docker-machine ip $${USER} 2>/dev/null` ; \
ports=`for container in $${containers}; do \
  docker inspect \
  --format '{{ .Config.ExposedPorts }}' $${container} | \
  sed 's,[^0-9 ],,g' ; \
done` ; \
for port in $${ports} ; do \
  printf "$${ip}:$${port}\n" ; \
done

# Show volumes on running containers
.PHONY: volumes
volumes:
	@ \
containers=`docker ps -q` ; \
for container in $${containers}; do \
printf 'Volumes on ' ; \
image=`docker ps --filter=id=$${container} --format='{{ .Image }}'` ; \
printf "$${image}:\n" ; \
docker inspect \
    --format '{{ .Config.Volumes }}' $${container} ; \
printf '\n' ; \
done

