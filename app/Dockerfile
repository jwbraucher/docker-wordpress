# app

FROM braucher/puppet
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Run app
RUN mkdir -p /var/www/app
WORKDIR /var/www/app
COPY ./app* /
ENTRYPOINT ["/app"]
CMD ["start"]

