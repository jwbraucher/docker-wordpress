# braucher/php 1.2.1

This [braucher/php](https://hub.docker.com/r/braucher/php/) docker image provides an Ubuntu 14.04 php5-fpm application container configured 
via the [mayflower/php puppet module](https://github.com/mayflower/puppet-php).

The [braucher/php](https://hub.docker.com/r/braucher/php/) image also includes the following:

* numerous PHP extensions  
(see [puppet/app/app.yaml](https://github.com/jwbraucher/docker-php/tree/latest/app/puppet/app.yaml)
for a complete list of the extensions installed)
* postfix
* /app and /app.* entrypoint scripts
* /fix-uids helper script for host volumes on Mac OS

## Usage
By default, ```/app start``` is the entrypoint and command, 
the daemon listens on port 9000, and files are served from ```/var/www/php```.

See the 
[docker-compose.yml from the sample-project branch](https://github.com/jwbraucher/docker-php/tree/sample-project/docker-compose.yml)
for an example of how to build a new project from this image using the 
following Docker images:  

* [braucher/php](https://hub.docker.com/r/braucher/php/) (this one)
* [braucher/fcgi](https://hub.docker.com/r/braucher/fcgi/)
* [mysql](https://hub.docker.com/r/_/mysql/)

If you fork the 
[sample-project](https://github.com/jwbraucher/docker-php/tree/sample-project/docker-compose.yml)
branch, modify the following files in your new project:
 - Makefile.local
 - docker-compose.yml, 
 - /app/app.* (leave /app/app alone)

#### add your project parameters as environment variables like this:
```/app.env```

#### using the default "start" docker command, scripts run like this:
```
/app.configure  
/app.install  
```

#### use the "install" command to download and install the app
```
/app.install  
```

#### use the "backup/restore" commands to manage application data
```
/app.backup
/app.restore
```

## Development
See DEVELOPMENT.md

## License
MIT license

