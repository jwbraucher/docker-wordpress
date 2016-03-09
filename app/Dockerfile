# docker base image based on Ubuntu

FROM braucher/php
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Install Wordpress
RUN apt-get update && \
  apt-get install -y --force-yes \
  wordpress postfix unzip

# Install wp-cli
RUN composer create-project wp-cli/wp-cli /opt/wp-cli --no-dev
RUN chmod a+x /opt/wp-cli/bin/wp
RUN ln -s /opt/wp-cli/bin/wp /usr/bin/wp

# Set alias for wp-cli for the root user
RUN echo alias \'wp=sudo -u www-data wp\' >> ~/.bashrc

# Wordpress install and startup script
COPY ./app* /

# Run wordpress
RUN mkdir -p /var/www/app
WORKDIR /var/www/app
ENTRYPOINT ["/app"]
CMD ["start"]

