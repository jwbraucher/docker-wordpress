# Development Instructions

# Installation

This project requires Docker Toolbox and GNU make. 

Install those, then run:
```
make machine

make env
# paste and execute environment command

make build

make install logs
# wait for install process to finish

make start logs
```

# Usage
All tasks in this project are performed by invoking GNU make.
Actions apply to all containers by default (e.g. make start),
but otherwise apply to the container with the shortest name
if the action can only apply to a single container (e.g. make logs).
If the command applies to a single container, a specific container
can be selected with the "service" environment variable.
(e.g. make logs service=app-db).

## Docker Machine Commands
Commands that setup and describe the docker environment.

#### Create and start a docker machine :
```make machine```

#### Stop a docker machine :
```make machine-stop```

#### Destroy a docker machine :
```make machine-clean```

#### Show environment variables to be copied into the current shell :
```make env```  
Copy and paste the environment setup command after this.  
Mac users can just 'paste' after running this command. 

#### Show network information for accessing running containers
```make net```

#### Show all volumes listed by their parent containers :
```make volumes```

## Build Commands
Commands to build images from Dockerfiles and related source code.

#### Build all images :
```make build```

#### Rebuild the 'app' image :
```make rebuild service=app```

#### Clean up stopped containers, intermediate images, app volumes :
```make clean```  
The volumes/export directory is excluded from cleaning.

#### Run ```make clean``` plus get rid of all local images :
```make distclean```

#### Clean up local stopped containers
```make clean-containers

#### Clean up untagged, intermediate images
```make clean-images

## Container Commands
Commands to start/stop/restart containers and to run commands like install or backup.

#### Start/Stop/Restart services :
```make start```   
```make stop service=app```   
```make restart```   

#### Start a shell on a running container :
```make cli service=app-web```
(picks container w/ shortest name by default)

#### Start up a new container and run a shell in it :
```make start-cli```  

#### Run software installation, backups, restores :
```make install```   
```make restore```   
```make backup```   

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
