# By default, build all Dockerfiles with cache enabled
# (set target to rebuild to disable the cache)
TARGET=build
PROJECTS:=$(shell find * -name Dockerfile -exec dirname {} \; )
default: $(PROJECTS)

.PHONY: $(PROJECTS)
$(PROJECTS):
	@for i in $(PROJECTS); do \
	  cd $${i} && \
	  $(MAKE) -f ../Makefile $(TARGET) PROJECT=$${i} ; \
	  cd .. ; \
	  done

.PHONY: build
build:
	docker build -t $(PROJECT) .

.PHONY: rebuild
rebuild: clean
	docker build -t $(PROJECT) --no-cache .

.PHONY: clean
clean: 
	-@for i in ${PROJECTS}; do docker rmi $${i}; done
	-docker-compose rm -f -v
	$(MAKE) garbage

.PHONY: garbage
garbage:
	$(eval CONTAINERS := $(shell docker ps -a -q --filter='status=exited') )
	-@for container in ${CONTAINERS}; do docker rm $${container}; done
	$(eval IMAGES := $(shell docker images | grep '^<none>' | awk '{print $$3}' ))
	-@for i in ${IMAGES}; do docker rmi $${i}; done

.PHONY: start
start:
	docker-compose up -d $(SERVICE)

.PHONY: stop
stop:
	$(eval CONTAINERS := $(shell docker ps -q $(SERVICE)) )
	@for container in ${CONTAINERS}; do docker stop $${container}; done

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
	docker exec -it $(CONTAINER) /bin/bash -c 'set -v'

.PHONY: start-cli
boot-cli:
	$(eval CONTAINER := $(shell docker images -q $(SERVICE) | head -1) )
	docker run -it --rm --entrypoint=/bin/bash $(CONTAINER) -o vi

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
	$(eval IP := $(shell docker-machine ip $(USER) ))
	$(eval CONTAINERS := $(shell docker ps -q) )
	$(eval PORTS := $(shell for container in ${CONTAINERS}; do \
          docker inspect \
            --format '{{ .Config.ExposedPorts }}' $${container} | \
	    sed 's,[^0-9 ],,g' ; \
	  done ) )
	@for port in ${PORTS} ; do printf "${IP}:$${port}\n"; done
