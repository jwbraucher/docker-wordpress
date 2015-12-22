# sample docker project

FROM ubuntu:14.04
MAINTAINER Jeff Braucher <jeff@braucher.net>

# Set the locale and terminal
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

