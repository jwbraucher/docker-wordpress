# Docker PHP

This repository provides a software template for a LAMP stack built 
with the following Docker containers:
* ubuntu-upstart:14.04 (see braucher/puppet:latest)
* mysql:5.6
* httpd:2.4

MySQL and Apache are standard Docker containers, the PHP container is configured
with puppet and provides additional common software dependencies for LAMP applications
as well as some helper scripts to configure the container.

The image provides a PHP5-FPM application container configured 
using puppet and the mayflower/puppet-php module.

## Usave
/php5-fpm is the default entrypoint. The daemon listens on port 9000.

## Development
See DEVELOPMENT.md

## License
MIT license

