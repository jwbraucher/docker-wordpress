# App

FROM braucher/puppet
MAINTAINER Jeff Braucher <jeff@braucher.net>

COPY ./fix-uids /
COPY ./app* /
ENTRYPOINT ["/app"]
CMD ["start"]

