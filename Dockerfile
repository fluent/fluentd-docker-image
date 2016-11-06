FROM alpine:3.4
MAINTAINER TAGOMORI Satoshi <tagomoris@gmail.com>

LABEL Description="Fluentd docker image" Vendor="Fluent Organization" Version="1.1"
ENV FLUENTD_VERSION=0.12.29 DUMB_INIT_VERSION=1.2.0 GOSU_VERSION=1.10 RUBY_VERSION=2.3.0


# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete build*' has no effect
RUN set -x \
&&  apk --no-cache --update add build-base ca-certificates ruby ruby-irb ruby-dev curl \
&&  echo 'gem: --no-document' >> /etc/gemrc \
&&  gem install oj \
&&  gem install json \
&&  gem install fluentd -v ${FLUENTD_VERSION} \
&&  curl -sSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 > /usr/bin/gosu \
&&  curl -sSL https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 > /usr/bin/dumb-init \
&&  apk del build-base ruby-dev curl \
&&  rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem

RUN chmod +x /usr/bin/gosu
RUN chmod +x /usr/bin/dumb-init

RUN mkdir -p /home/fluent
# Tell ruby to install packages as use
RUN echo "gem: --user-install --no-document" >> /home/fluent/.gemrc
ENV PATH /home/fluent/.gem/ruby/${RUBY_VERSION}/bin:$PATH
ENV GEM_PATH /home/fluent/.gem/ruby/${RUBY_VERSION}:$GEM_PATH

# for log storage (maybe shared with host)
RUN mkdir -p /fluentd/log
# configuration/plugins path (default: copied from .)
RUN mkdir -p /fluentd/etc /fluentd/plugins

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

EXPOSE 24224 5140

ENTRYPOINT ["/entrypoint.sh"]
