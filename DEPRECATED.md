# About deprecated images

Put the historical deprecated contents here.

### Old v1.4 images

This is for backward compatibility. Use "Current images" instead.

- `v1.4.2-2.0`, `v1.4-2`
  [(v1.4/alpine/Dockerfile)][fluentd-1-4-alpine]
- `v1.4.2-onbuild-2.0`, `v1.4-onbuild-2`
  [(v1.4/alpine-onbuild/Dockerfile)][fluentd-1-4-alpine-onbuild]
- `v1.4.2-debian-2.0`, `v1.4-debian-2`
  [(v1.4/debian/Dockerfile)][fluentd-1-4-debian]
- `v1.4.2-debian-onbuild-2.0`, `v1.4-debian-onbuild-2`, `edge-debian-onbuild`
  [(v1.4/debian-onbuild/Dockerfile)][fluentd-1-4-debian-onbuild]
- `v1.4.2-windows-2.0`, `v1.4-windows-2`
  [(v1.4/windows/Dockerfile)][fluentd-1-4-windows]

### v0.12 images

Support of fluentd v0.12 has ended in 2019. We don't recommend v0.12 for new deployment.

- `v0.12.43-2.0`, `v0.12-2`
  [(v0.12/alpine/Dockerfile)][fluentd-0-12-alpine]
- `v0.12.43-onbuild-2.0`, `v0.12-onbuild-2`
  [(v0.12/alpine-onbuild/Dockerfile)][fluentd-0-12-alpine-onbuild]
- `v0.12.43-debian-2.0`, `v0.12-debian-2`
  [(v0.12/debian/Dockerfile)][fluentd-0-12-debian]
- `v0.12.43-debian-onbuild-2.0`, `v0.12-debian-onbuild-2`
  [(v0.12/debian-onbuild/Dockerfile)][fluentd-0-12-debian-onbuild]

You can use older versions via tag. See [tag page on Docker Hub](https://hub.docker.com/r/fluent/fluentd/tags/).

We recommend to use debian version for production because it uses jemalloc to mitigate memory fragmentation issue.

### Tips for building your own older image

This section is for existing users. Don't recommend for new deployment.

#### Alpine version

```Dockerfile
FROM fluent/fluentd:v1.3-onbuild-1

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish

RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install \
        fluent-plugin-elasticsearch \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
```

#### Debian version

```Dockerfile
FROM fluent/fluentd:v1.3-debian-onbuild-1

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install \
        fluent-plugin-elasticsearch \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
```


