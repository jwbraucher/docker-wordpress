# docker base image based on Ubuntu

FROM ubuntu-upstart:14.04
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Set the locale and terminal
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Fix initctl to report upstart version
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN echo '#!/bin/bash\nif [ $1 == "--version" ]\nthen\n  echo "initctl (upstart 1.12.1)"\nfi\n/bin/true' > /sbin/initctl
RUN chmod 755 /sbin/initctl

