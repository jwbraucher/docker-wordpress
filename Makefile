# Configuration
export
SHELL := /bin/bash
ip := 0.0.0.0
command := default
this_file := $(lastword $(MAKEFILE_LIST))

### Generic Makefile config

# Local Project Makefile ( should define app variable )
include Makefile.local
machine := ${app}

# List available commands
# (http://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile)
.PHONY: help list-commands
help list-commands:
	@echo "The following commands are available:";
	@$(MAKE) -pRrq -f $(this_file) : 2>/dev/null | \
awk -v RS= -F: '/^# File/,/^# Finished Make data base/ \
    {if ($$1 !~ "^[#.]") {print $$1}}' | \
    sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

### Build Commands

# Build the images
# if "rebuild" target is added, build images with --no-cache
.PHONY: build rebuild
build rebuild:
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
-mindepth 1 -maxdepth 1 \
-type d -not -name export \
-exec find {} -type f -delete \; ; \
find volumes/ \
-mindepth 1 -maxdepth 1 \
-type d -not -name export \
-exec find {} -type d -mindepth 1 -empty -delete \;

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
export ip=`docker-machine ip $${machine} 2>/dev/null` ; \
export command=$@ ; \
docker-compose up -d $${service}

# running container commands
.PHONY: backup configure
backup configure:
	@ set -x ; \
export command=$@ ; \
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
docker-compose run --rm --entrypoint /bin/bash $${theservice} -o vi

### Docker Machine commands

# manage docker machine
.PHONY: machine
machine:
	@- set -x ; \
docker-machine create --driver virtualbox --virtualbox-memory 8096 $(machine) ; \
docker-machine start $(machine)

.PHONY: machine-stop
machine-stop:
	docker-machine stop $(machine)

.PHONY: machine-clean
machine-clean:
	docker-machine rm -y $(machine)

# Show environment command, and add to clipboard to setup local environment
.PHONY: env
env:
	@- docker-machine env $(machine) ; \
  docker-machine env $(machine) | \
  tail -1 | sed 's,^# ,,' | pbcopy

# Show network connection information for running containers
.PHONY: net
net:
	@echo "Network Configuration:" ; \
containers=`docker ps -q 2>/dev/null` ; \
ip=`docker-machine ip $${machine} 2>/dev/null` ; \
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

