# braucher/wordpress

This [braucher/wordpress](https://hub.docker.com/r/braucher/wordpress/) docker image provides an Ubuntu 14.04 Wordpress application container.

The [braucher/wordpress](https://hub.docker.com/r/braucher/wordpress/) image also includes the following:

* numerous PHP extensions (gd, ldap, curl, imagick, mcrypt, imagick, mysqlnd, xsl, etc.)
* postfix
* /wordpress entrypoint script
* /fix-uids helper script for host volumes on Mac OS

## Usage

See the
[docker-compose.yml from the sample-project branch](https://github.com/jwbraucher/docker-wordpress/tree/sample-project/docker-compose.yml)
for an example of how to build a new project from this image using the
following Docker images:

* [braucher/wordpress](https://hub.docker.com/r/braucher/wordpress/) (this one)
* [braucher/fcgi](https://hub.docker.com/r/braucher/fcgi/)
* [mysql](https://hub.docker.com/r/_/mysql/)

If you fork the sample-project branch, just modify Makefile.local and docker-compose.yml
to change the app name in the new container.


### Environment Variables

Whenever this container starts it re-configures Wordpress.
Be sure to supply the correct runtime environment variables when
you first launch the containers. Docker will remember the environment
variables for subsequent container restarts.

See the [/app.env script](https://github.com/jwbraucher/docker-wordpress/blob/master/app/app.env)
for all accepted parameters. 

## Development
See DEVELOPMENT.md

## License
MIT license

