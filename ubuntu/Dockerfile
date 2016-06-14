FROM ubuntu:14.04
MAINTAINER TAGOMORI Satoshi <tagomoris@gmail.com>
LABEL Description="Fluentd docker image" Vendor="Fluent Organization" Version="1.0"

RUN apt-get update -y && apt-get install -y \
              autoconf \
              bison \
              build-essential \
              curl \      
              git \
              libffi-dev \              
              libgdbm3 \
              libgdbm-dev \
              libncurses5-dev \
              libreadline6-dev \              
              libssl-dev \
              libyaml-dev \
              zlib1g-dev \              
        && rm -rf /var/lib/apt/lists/*

RUN useradd ubuntu -d /home/ubuntu -m -U
RUN chown -R ubuntu:ubuntu /home/ubuntu

# for log storage (maybe shared with host)
RUN mkdir -p /fluentd/log
# configuration/plugins path (default: copied from .)
RUN mkdir -p /fluentd/etc
RUN mkdir -p /fluentd/plugins

RUN chown -R ubuntu:ubuntu /fluentd

USER ubuntu
WORKDIR /home/ubuntu

RUN git clone https://github.com/tagomoris/xbuild.git /home/ubuntu/.xbuild
RUN /home/ubuntu/.xbuild/ruby-install 2.3.1 /home/ubuntu/ruby

ENV PATH /home/ubuntu/ruby/bin:$PATH
RUN gem install fluentd -v 0.12.26

# RUN gem install fluent-plugin-webhdfs

COPY fluent.conf /fluentd/etc/
ONBUILD COPY fluent.conf /fluentd/etc/
ONBUILD COPY plugins /fluentd/plugins/

WORKDIR /home/ubuntu

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

EXPOSE 24224

### docker run -p 24224 -v `pwd`/log: -v `pwd`/log:/home/ubuntu/log fluent/fluentd:latest
CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
