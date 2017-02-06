Fluentd Docker Image
====================

[![Build Status](https://travis-ci.org/fluent/fluentd-docker-image.svg?branch=master)](https://travis-ci.org/fluent/fluentd-docker-image)
[![Docker Stars](https://img.shields.io/docker/stars/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd)
[![Docker Pulls](https://img.shields.io/docker/pulls/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd)
[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/fluent/fluentd/latest.svg)](https://hub.docker.com/r/fluent/fluentd)
[![ImageLayers Layers](https://img.shields.io/imagelayers/layers/fluent/fluentd/latest.svg)](https://hub.docker.com/r/fluent/fluentd)




## Supported tags and respective `Dockerfile` links

- `v0.12.32`, `v0.12`, `stable`, `latest`
  [(v0.12/alpine/Dockerfile)][101]
- `v0.12.32-onbuild`, `v0.12-onbuild`, `stable-onbuild`, `onbuild`
  [(v0.12/alpine-onbuild/Dockerfile)][102]
- `v0.14.12`, `v0.14`, `edge`
  [(v0.14/alpine/Dockerfile)][103]
- `v0.14.12-onbuild`, `v0.14-onbuild`, `edge-onbuild`
  [(v0.14/alpine-onbuild/Dockerfile)][104]




## What is Fluentd?

Fluentd is an open source data collector, which lets you unify the data
collection and consumption for a better use and understanding of data.

> [www.fluentd.org](http://www.fluentd.org/)

![Fluentd Logo](http://www.fluentd.org/assets/img/miscellany/fluentd-logo.png)




## How to use this image

To create endpoint that collectc logs on your host just run:

```bash
docker run -d -p 24224:24224 -v /data:/fluentd/log fluent/fluentd
```

Default configurations are to:

- listen port `24224` for Fluentd forward protocol
- store logs with tag `docker.**` into `/fluentd/log/docker.*.log`
  (and symlink `docker.log`)
- store all other logs into `/fluentd/log/data.*.log` (and symlink `data.log`)



## Environment Variables

Environment variable below are configurable to control how to execute fluentd process:


### `FLUENTD_CONF`

This variable allows you to specify configuration file name that will be used
in `-c` Fluentd command line option.

If you want to use your own configuration file (without any optional plugins),
you can do it with this environment variable and Docker volumes (`-v` option
of `docker run`).

1. Write configuration file with filename `yours.conf`.
2. Execute `docker run` with `-v /path/to/dir:/fluentd/etc`
   to share `/path/to/dir/yours.conf` in container,
   and `-e FLUENTD_CONF=yours.conf` to read it.


### `FLUENTD_OPT`

Use this variable to specify other Fluentd command line options,
like `-v` or `-q`.




## Image versions

This image is based on the popular [Alpine Linux project][1], available in
[the alpine official image][2].
Alpine Linux is much smaller than most distribution base images (~5MB), and
thus leads to much slimmer images in general.

Since `v0.12.26`, tags are separated into `vX.Y.Z` and `vX.Y.Z-onbuild`.


### `stable`, `latest`

Latest version of stable Fluentd branch (currently `v0.12`).


### `edge`

Latest version of edge Fluentd branch (currently `v0.14`).


### `vX.Y`

Latest version of `vX.Y` Fluentd branch.


### `vX.Y.Z`

Concrete `vX.Y.Z` version of Fluentd.


### `onbuild`, `xxx-onbuild`

This image makes building derivative images easier.  
See ["How to build your own image"](#how-to-build-your-own-image) section for
more details.


### Ubuntu based image

This is deprecated. You can use `ubuntu-base` tag for your build but we don't
maintain ubuntu based image with latest Fluentd release.
We recommend to fork `ubuntu/Dockerfile` for your case.




## How to build your own image

You can build a customized image based on Fluentd's `onbuild` image.
Customized image can include plugins and `fluent.conf` file.


### 1. Create a working directory

We will use this directory to build a Docker image.
Type following commands on a terminal to prepare a minimal project first:

```bash
# Create project directory.
mkdir custom-fluentd
cd custom-fluentd

# Download default fluent.conf. this file will be copied to the new image.
curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/fluent.conf > fluent.conf

# Create plugins directory. plugins scripts put here will be copied to the new image.
mkdir plugins

# Download sample Dockerfile.
curl https://raw.githubusercontent.com/fluent/fluentd-docker-image/master/Dockerfile.sample > Dockerfile
```


### 2. Customize `fluent.conf`

Documentation of `fluent.conf` is available at [docs.fluentd.org][3].


### 3. Customize Dockerfile to install plugins (optional)

You can install [Fluentd plugins][4] using Dockerfile.
Sample Dockerfile installs `fluent-plugin-secure-forward`.
To add plugins, edit `Dockerfile` as following:

```Dockerfile
FROM fluent/fluentd:latest-onbuild
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

# cutomize following "gem install fluent-plugin-..." line as you wish

USER root
RUN apk --no-cache add sudo build-base ruby-dev && \

    sudo -u fluent gem install fluent-plugin-elasticsearch fluent-plugin-record-reformer && \

    rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem && sudo -u fluent gem sources -c && \
    apk del sudo build-base ruby-dev

EXPOSE 24284

USER fluent
CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
```

Note:
This example runs `apk add build-base ruby-dev` to be able to install
Fluentd plugins which require native extensions (they are removed immediately
after plugin installation).
If you're sure that plugins don't include native extensions, you can omit it
to make image build faster.


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
mkdir log
docker run -it --rm --name custom-docker-fluent-logger -v `pwd`/log:/fluentd/log custom-fluentd:latest
```

Open another terminal and type following command to inspect IP address.
Fluentd is running on this IP address:

```bash
docker inspect -f '{{.NetworkSettings.IPAddress}}' custom-docker-fluent-logger
```

Let's try to use another docker container to send its logs to Fluentd.

```bash
docker run --log-driver=fluentd --log-opt fluentd-address=FLUENTD.ADD.RE.SS:24224 python:alpine echo Hello
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

We can't notice comments in the DockerHub so don't use them for reporting issue
or asking question.

If you have any problems with or questions about this image, please contact us
through a [GitHub issue](https://github.com/fluent/fluentd-docker-image/issues).





[1]: http://alpinelinux.org
[2]: https://hub.docker.com/_/alpine
[3]: http://docs.fluentd.org
[4]: http://www.fluentd.org/plugins
[5]: http://www.fluentd.org/guides/recipes/docker-logging
[6]: https://docs.docker.com/engine/reference/logging/fluentd
[101]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.12/alpine/Dockerfile
[102]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.12/alpine-onbuild/Dockerfile
[103]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.14/alpine/Dockerfile
[104]: https://github.com/fluent/fluentd-docker-image/blob/master/v0.14/alpine-onbuild/Dockerfile
