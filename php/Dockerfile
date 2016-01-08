# lamp stack built with puppet

FROM puppet
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Configure the system with puppet
COPY ./php/puppet/ /puppet/
WORKDIR /puppet
RUN librarian-puppet install
RUN /puppet-apply \
  --hiera_config=./hiera.yaml \
  --modulepath=./modules \
  ./site.pp

# Fix comments in xhprof.ini
RUN sed -i 's/^#/;/' /etc/php5/mods-available/xhprof.ini

# Enable upload progress in apcu
RUN echo apc.rfc1867 = 1 >> /etc/php5/mods-available/apcu.ini

# Ensure php5-fpm won't run via upstart
RUN echo 'manual' > /etc/init/php5-fpm.override
RUN service php5-fpm stop

# Run php5-fpm on port 9000
EXPOSE 9000
COPY php/php5-fpm /php5-fpm
ENTRYPOINT ["/php5-fpm"]
