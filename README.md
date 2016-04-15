# braucher/app 2.2.1

This [braucher/app](https://hub.docker.com/r/braucher/app/) docker image provides an Ubuntu 14.04 application container.

The [braucher/app](https://hub.docker.com/r/braucher/app/) image includes the following features:

## Features Include:
* Makefile
* /app entrypoint
* /fix-uids (for mac os host volumes)
* docker-compose example
* wait for database container (app.configure)

## Usage

By default, ```/app start``` is the entrypoint and command.  
Run ```/app install``` to install.  
Run ```/app backup``` to backup.  

See the [docker-compose.yml from the sample-project branch](https://github.com/jwbraucher/docker-app/tree/latest/docker-compose.yml)
for an example of how to build a new project from this image using the following Docker images:
* [braucher/app](https://hub.docker.com/r/braucher/app/) (this one)
* [braucher/fcgi](https://hub.docker.com/r/braucher/fcgi/)
* [mysql](https://hub.docker.com/r/_/mysql/)

To start your own image, fork this project and modify the following files:  
* Makefile.local  
* docker-compose.yml (change image names)  
* app/app.*  

### Environment Variables

See the [/app.env script](https://github.com/jwbraucher/docker-app/tree/latest/app/app.env)
for all accepted parameters. 

## Development
See DEVELOPMENT.md

## License
MIT license

