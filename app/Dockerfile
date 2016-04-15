# docker base image based on Ubuntu

FROM braucher/wordpress
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Wordpress install and startup script
COPY ./app* /

# Run wordpress
RUN mkdir -p /var/www/app
WORKDIR /var/www/app
ENTRYPOINT ["/app"]
CMD ["start"]

