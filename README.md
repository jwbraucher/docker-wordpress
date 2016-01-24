# braucher/php 1.1.0

This [braucher/php](https://hub.docker.com/r/braucher/php/) docker image provides an Ubuntu 14.04 php5-fpm application container configured 
via the [mayflower/php puppet module](https://github.com/mayflower/puppet-php).

The [braucher/php](https://hub.docker.com/r/braucher/php/) image also includes the following:

* numerous PHP extensions  
(see [puppet/php/php.yaml](https://github.com/jwbraucher/docker-php/tree/latest/php/puppet/php.yaml)
for a complete list of the extensions installed)
* postfix
* /php entrypoint script (serves files in ```$DOCUMENT_ROOT```)
* /fix-uids helper script for host volumes on Mac OS

## Usage
By default, ```/php5``` is the entrypoint, the daemon listens on port 9000, and files are served from ```/var/www/php```.

See the 
[docker-compose.yml from the sample-project branch](https://github.com/jwbraucher/docker-php/blob/sample-project/docker-compose.yml)
for an example of how to build a new project from this image using the 
following Docker images:  

* [braucher/php](https://hub.docker.com/r/braucher/php/) (this one)
* [braucher/fcgi](https://hub.docker.com/r/braucher/fcgi/)
* [mysql](https://hub.docker.com/r/_/mysql/)

If you fork the sample-project branch, just modify Makefile.local 
to change the app name in the new container.

Run the following to correct the permissions on a host volume for a runtime user 
in your container (needed for host volumes such as those on Mac OS):

```
/fix-uids [mountpoint] [runtime user]
```

## Development
See DEVELOPMENT.md

## License
MIT license

