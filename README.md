# braucher/php

This [braucher/php](https://hub.docker.com/r/braucher/php/) docker image provides an Ubuntu 14.04 php5-fpm application container configured 
via the [mayflower/php puppet module](https://github.com/mayflower/puppet-php).

Puppet and related tools are provided from the [braucher/puppet base container](https://github.com/jwbraucher/docker-puppet).

This Github repository provides a software template for a LAMP stack built 
with the following Docker containers:

* [braucher/php](https://hub.docker.com/r/braucher/php/) (this one)
* [mysql:5.6](https://hub.docker.com/r/_/mysql/)
* [httpd:2.4](https://hub.docker.com/r/_/httpd/)

The [braucher/php](https://hub.docker.com/r/braucher/php/) image also includes the following:

* numerous PHP extensions (gd, ldap, curl, imagick, mcrypt, imagick, mysqlnd, xsl, etc.)
* postfix
* /php5-fpm entrypoint script (serves files in WORKDIR)
* /fix-uids helper script for host volumes on Mac OS

## Usage
/php5-fpm is the default entrypoint. The daemon listens on port 9000. PHP files are
served from /var/www/php using the enclosed docker-compose.yaml.

Modify Makefile.local to change the app name and build your own containers. 
If you do change the app name, be sure to rename the containers in 
docker-compose.yaml as well.

Run the following to start php5-fpm in your container:

```
/php5-fpm [options]
```

Run the following to correct the permissions on a host volume for a runtime user 
in your container (needed for host volumes such as Mac OS):

```
/fix-uids [mountpoint] [runtime user]
```

## Development
See DEVELOPMENT.md

## License
MIT license

