Fluentd Docker Image
====================

[![Build Status](https://travis-ci.org/fluent/fluentd-docker-image.svg?branch=master)](https://travis-ci.org/fluent/fluentd-docker-image)
[![Docker Stars](https://img.shields.io/docker/stars/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd)
[![Docker Pulls](https://img.shields.io/docker/pulls/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd)
[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/fluent/fluentd/latest.svg)](https://hub.docker.com/r/fluent/fluentd)
[![ImageLayers Layers](https://img.shields.io/imagelayers/layers/fluent/fluentd/latest.svg)](https://hub.docker.com/r/fluent/fluentd)

## What is Fluentd?

Fluentd is an open source data collector, which lets you unify the data
collection and consumption for a better use and understanding of data.

> [www.fluentd.org](https://www.fluentd.org/)

![Fluentd Logo](https://www.fluentd.org/assets/img/miscellany/fluentd-logo.png)

## Supported tags and respective `Dockerfile` links

### Current images (Edge)

These tags have image version postfix. This updates many places so we need feedback for improve/fix the images.

Current images use fluentd v1 serise.

- `v1.11.4-1.0`, `v1.11-1`, `edge`
  [(v1.10/alpine/Dockerfile)][fluentd-1-alpine]
- `v1.11.4-debian-1.0`, `v1.11-debian-1`, `edge-debian`
  [(v1.10/debian/Dockerfile)][fluentd-1-debian]
- `v1.11.4-debian-arm64-1.0`, `v1.11-debian-arm64-1`, `edge-debian-arm64`
  [(v1.10/arm64/debian/Dockerfile)][fluentd-1-debian-arm64]
- `v1.11.4-debian-armhf-1.0`, `v1.11-debian-armhf-1`, `edge-debian-armhf`
  [(v1.10/armhf/debian/Dockerfile)][fluentd-1-debian-armhf]
- `v1.11.4-windows-1.0`, `v1.11-windows-1`
  [(v1.10/windows/Dockerfile)][fluentd-1-windows]

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


### Using Kubernetes?

Check [fluentd-kubernetes-daemonset](https://github.com/fluent/fluentd-kubernetes-daemonset) images.

## The detail of image tag

This image is based on the popular [Alpine Linux project][1], available in
[the alpine official image][2], and Debian images.

### For current images

#### `edge`

Latest released version of Fluentd. This tag is mainly for testing.

#### `vX.Y-A`

Latest version of `vX.Y` Fluentd branch.

`A` will be incremented when image has major changes.

When fluentd version is updated, A is reset to `1`.

#### `vX.Y.Z-A.B`

Concrete `vX.Y.Z` version of Fluentd. This tag is recommeded for the production environment.

`A` will be incremented when image has major changes.
`B` will be incremented when image has small changes, e.g. library update or bug fixes.

When fluentd version is updated, `A.B` is reset to `1.0`.

#### `onbuild` included tag

`onbuild` images are deprecated. Use non-`onbuild ` images instead to build your image.
New images, v1.5 or later, don't provide `onbuild` version.

#### `debian` included tag

The image based on [Debian Linux image][7].
You may use this image when you require plugins which cannot be installed on Alpine (like `fluent-plugin-systemd`).

#### `armhf` included tag

The `armhf` images use ARM base images for use on devices such as Raspberry Pis.

Furthermore, the base images enable support for cross-platform builds using the cross-build tools from [resin.io](https://docs.resin.io/reference/base-images/resin-base-images/#resin-xbuild-qemu).

In order to build these images natively on ARM devices, the `CROSS_BUILD_START` and `CROSS_BUILD_END` Docker build arguments must be set to the shell no-op (`:`), for example:
```bash
docker build --build-arg CROSS_BUILD_START=":" --build-arg CROSS_BUILD_END=":" -t fluent/fluentd:v1.3-onbuild-1 v1.3/armhf/alpine-onbuild
```
(assuming the command is run from the root of this repository).

### For older images

These images/tags are kept for backward compatibility. No update anymore and don't use for new deployment. Use "current images" instead.

#### `stable`, `latest`

Latest version of stable Fluentd branch (currently `v1.3-1`).

#### `vX.Y`

Latest version of `vX.Y` Fluentd branch.

#### `vX.Y.Z`

Concrete `vX.Y.Z` version of Fluentd.

#### `onbuild` included tag, `debian` included tag, `armhf` included tag

Same as current images.

## How to use this image

To create endpoint that collects logs on your host just run:

```bash
docker run -d -p 24224:24224 -p 24224:24224/udp -v /data:/fluentd/log fluent/fluentd:v1.3-debian-1
```

Default configurations are to:

- listen port `24224` for Fluentd forward protocol
- store logs with tag `docker.**` into `/fluentd/log/docker.*.log`
  (and symlink `docker.log`)
- store all other logs into `/fluentd/log/data.*.log` (and symlink `data.log`)

## Providing your own configuration file and additional options

`fluentd` arguments can be appended to the `docker run` line

For example, to provide a bespoke config and make `fluentd` verbose, then:

`docker run -ti --rm -v /path/to/dir:/fluentd/etc fluentd -c /fluentd/etc/<conf> -v`

The first `-v` tells Docker to share '/path/to/dir' as a volume and mount it at /fluentd/etc
The `-c` after the container name (fluentd) tells `fluentd` where to find the config file
The second `-v` is passed to `fluentd` to tell it to be verbose

## Change running user

Use `-u` option with `docker run`.

`docker run -p 24224:24224 -u foo -v ...`

## How to build your own image

You can build a customized image based on Fluentd's image.
Customized image can include plugins and `fluent.conf` file.

### 1. Create a working directory

We will use this directory to build a Docker image.
Type following commands on a terminal to prepare a minimal project first:

```bash
# Create project directory.
mkdir custom-fluentd
cd custom-fluentd

# Download default fluent.conf and entrypoint.sh. This file will be copied to the new image.
# VERSION is v1.7 like fluentd version and OS is alpine or debian.
# Full example is https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/v1.10/debian/fluent.conf

curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/VERSION/OS/fluent.conf > fluent.conf

curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/VERSION/OS/entrypoint.sh > entrypoint.sh

# Create plugins directory. plugins scripts put here will be copied to the new image.
mkdir plugins

curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/Dockerfile.sample > Dockerfile
```

### 2. Customize `fluent.conf`

Documentation of `fluent.conf` is available at [docs.fluentd.org][3].

### 3. Customize Dockerfile to install plugins (optional)

You can install [Fluentd plugins][4] using Dockerfile.
Sample Dockerfile installs `fluent-plugin-elasticsearch`.
To add plugins, edit `Dockerfile` as following:

### 3.1 For current images

#### Alpine version

```Dockerfile
FROM fluent/fluentd:v1.11-1

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install fluent-plugin-elasticsearch \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

USER fluent
```

#### Debian version

```Dockerfile
FROM fluent/fluentd:v1.11-debian-1

# Use root account to use apt
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install fluent-plugin-elasticsearch \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

USER fluent
```

#### Note

These example run `apk add`/`apt-get install` to be able to install
Fluentd plugins which require native extensions (they are removed immediately
after plugin installation).
If you're sure that plugins don't include native extensions, you can omit it
to make image build faster.

### 3.2 For older images

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

### 4. Build image

Use `docker build` command to build the image.
This example names the image as `custom-fluentd:latest`:

```bash
docker build -t custom-fluentd:latest ./
```

### 5. Test it

Once the image is built, it's ready to run.
Following commands run Fluentd sharing `./log` directory with the host machine:

```bash
mkdir -p log
docker run -it --rm --name custom-docker-fluent-logger -v $(pwd)/log:/fluentd/log custom-fluentd:latest
```

Open another terminal and type following command to inspect IP address.
Fluentd is running on this IP address:

```bash
docker inspect -f '{{.NetworkSettings.IPAddress}}' custom-docker-fluent-logger
```

Let's try to use another docker container to send its logs to Fluentd.

```bash
docker run --log-driver=fluentd --log-opt tag="docker.{{.ID}}" --log-opt fluentd-address=FLUENTD.ADD.RE.SS:24224 python:alpine echo Hello
# and force flush buffered logs
docker kill -s USR1 custom-docker-fluent-logger
```
(replace `FLUENTD.ADD.RE.SS` with actual IP address you inspected at
the previous step)

You will see some logs sent to Fluentd.

### References

[Docker Logging | fluentd.org][5]

[Fluentd logging driver - Docker Docs][6]

## Issues

We can't notice comments in the DockerHub so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us
through a [GitHub issue](https://github.com/fluent/fluentd-docker-image/issues).

[1]: http://alpinelinux.org
[2]: https://hub.docker.com/_/alpine
[3]: https://docs.fluentd.org
[4]: https://www.fluentd.org/plugins
[5]: https://www.fluentd.org/guides/recipes/docker-logging
[6]: https://docs.docker.com/engine/reference/logging/fluentd
[7]: https://hub.docker.com/_/debian
[fluentd-0-12-alpine]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.12/alpine/Dockerfile
[fluentd-0-12-alpine-onbuild]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.12/alpine-onbuild/Dockerfile
[fluentd-0-12-debian]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.12/debian/Dockerfile
[fluentd-0-12-debian-onbuild]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.12/debian-onbuild/Dockerfile
[fluentd-1-4-alpine]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.4/alpine/Dockerfile
[fluentd-1-4-alpine-onbuild]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.4/alpine-onbuild/Dockerfile
[fluentd-1-4-debian]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.4/debian/Dockerfile
[fluentd-1-4-debian-onbuild]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.4/debian-onbuild/Dockerfile
[fluentd-1-4-windows]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.4/windows/Dockerfile
[fluentd-1-alpine]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.10/alpine/Dockerfile
[fluentd-1-debian]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.10/debian/Dockerfile
[fluentd-1-debian-arm64]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.10/arm64/debian/Dockerfile
[fluentd-1-debian-armhf]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.10/armhf/debian/Dockerfile
[fluentd-1-windows]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.10/windows/Dockerfile
