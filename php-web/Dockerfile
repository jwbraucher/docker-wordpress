# httpd container for wordpress

FROM httpd:2.4
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Install some tools
RUN apt-get update && apt-get install -y vim less

# Setup apache
RUN echo "Include conf/php5-fpm.conf" >> /usr/local/apache2/conf/httpd.conf
COPY ./php5-fpm.conf /usr/local/apache2/conf/

