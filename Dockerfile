# lamp stack built with puppet

FROM jwbraucher/docker-puppet
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Configure the system with puppet
COPY ./puppet/ /puppet/
WORKDIR /puppet
RUN librarian-puppet install
RUN /puppet-apply \
  --hiera_config=./hiera.yaml \
  --modulepath=./modules \
  ./site.pp

# Ensure php5-fpm won't run via upstart
RUN echo 'manual' > /etc/init/php5-fpm.override
RUN service php5-fpm stop

# Run php5-fpm on port 9000
EXPOSE 9000
ENTRYPOINT ["php5-fpm", "--nodaemonize", "--fpm-config", "/etc/php5/fpm/php-fpm.conf" ]
