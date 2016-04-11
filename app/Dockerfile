# App

FROM braucher/puppet
MAINTAINER Jeff Braucher <jeff@braucher.net>

COPY ./fix-uids /
COPY ./app* /

EXPOSE 9000
ENTRYPOINT ["/app"]
CMD ["start"]

