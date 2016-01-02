# Ubuntu base image

FROM ubuntu-upstart:14.04
MAINTAINER Jeff Braucher <jeff@braucher.net>

# terminal and locale settings
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# compilers
RUN apt-get update && apt-get install -y \
  make \
  software-properties-common \
  ruby \
  ruby-dev \
  git

