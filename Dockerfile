# lamp stack built with puppet

FROM jwbraucher/docker-puppet
MAINTAINER Jeff Braucher <jeff@braucher.net>

COPY ./puppet/ /puppet/
WORKDIR /puppet
RUN librarian-puppet install
RUN /puppet-apply \
  --hiera_config=./hiera.yaml \
  --modulepath=./modules \
  ./site.pp
