# docker base image based on Ubuntu

FROM braucher/php
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Install Wordpress
RUN apt-get update && \
  apt-get install -y wordpress postfix

# Disable Apache service
RUN echo 'manual' > /etc/init/apache2.override
RUN service apache2 stop

# Disable Postfix service
RUN update-rc.d postfix disable
RUN service postfix stop

# Install wp-cli
RUN composer create-project wp-cli/wp-cli /opt/wp-cli --no-dev
RUN chmod a+x /opt/wp-cli/bin/wp
RUN ln -s /opt/wp-cli/bin/wp /usr/bin/wp

# Set alias for wp-cli for the root user
RUN echo alias \'wp=sudo -u www-data wp\' >> ~/.bashrc

# Wordpress install and startup script
COPY ./app* /

# Run wordpress
ENTRYPOINT ["/app"]
CMD ["start"]
