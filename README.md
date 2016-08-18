# Fluentd docker image

[![Docker Stars](https://img.shields.io/docker/stars/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd/)
[![Docker Pulls](https://img.shields.io/docker/pulls/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd/)
[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/fluent/fluentd/latest.svg)](https://hub.docker.com/r/fluent/fluentd/)
[![ImageLayers Layers](https://img.shields.io/imagelayers/layers/fluent/fluentd/latest.svg)](https://hub.docker.com/r/fluent/fluentd/)

This container image is to create endpoint to collect logs on your host.

```
docker run -d -p 24224:24224 -v /data:/fluentd/log fluent/fluentd
```

Default configurations are to:

* listen port `24224` for Fluentd forward protocol
* store logs with tag `docker.**` into `/fluentd/log/docker.*.log` (and symlink `docker.log`)
* store all other logs into `/fluentd/log/data.*.log` (and symlink data.log)

This image uses Alpine Linux. Since v0.12.26, we separate tags into `vX.XX.XX` and `vX.XX.XX-onbuild`.

### Ubuntu based image

This is deprecated. You can use `ubuntu-base` tag for your build but we don't maintain ubuntu based image with latest Fluentd release.
We recommend to fork `ubuntu/Dockerfile` for your case.

## Configurable ENV variables

Environment variable below are configurable to control how to execute fluentd process:

### FLUENTD_CONF

It's for configuration file name, specified for `-c`.

If you want to use your own configuration file (without any optional plugins), you can use it over this ENV variable and -v option.

1. write configuration file with filename `yours.conf`
2. execute `docker run` with `-v /path/to/dir:/fluentd/etc` to share `/path/to/dir/yours.conf` in container, and `-e FLUENTD_CONF=yours.conf` to read it

### FLUENTD_OPT

Use this variable to specify other options, like `-v` or `-q`.

## How to build your own image

You can build a customized image based on Fluentd's `onbuild` image. Customized image can include plugins, fluent.conf file, and plugins.

### 1. Create a working directory

We will use this diretory to build a docker image. Type following commands on a terminal to prepate a minimal project first:

```
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

### 3. Customize fluent.conf

Documentation of `fluent.conf` is available at [docs.fluentd.org](http://docs.fluentd.org/).

### 4. Customize Dockerfile to install plugins (optional)

You can use [Fluentd plugins](http://www.fluentd.org/plugins) by installing them using Dockerfile. Sample Dockerfile installs `fluent-plugin-secure-forward`. To add plugins, edit `Dockerfile` as following:

```
FROM fluent/fluentd:latest-onbuild
MAINTAINER YOUR_NAME <...@...>
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

# cutomize following "gem install fluent-plugin-..." line as you wish

USER root
RUN apk --no-cache --update add sudo build-base ruby-dev && \

    sudo -u fluent gem install fluent-plugin-elasticsearch fluent-plugin-record-reformer && \

    rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem && sudo -u fluent gem sources -c && \
    apk del sudo build-base ruby-dev && rm -rf /var/cache/apk/*

EXPOSE 24284

USER fluent
CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
```

### 5. Build image

Use `docker build` command to build the image. This example names the image "custom-fluentd:latest":

```
docker build -t custom-fluentd:latest ./
```

### 6. Testing

Once the image is built, it's ready to run. Following commands run Fluentd sharing `./log` directory with the host machine:

```
mkdir log
docker run -it --rm --name custom-docker-fluent-logger -v `pwd`/log:/fluentd/log custom-fluentd:latest
```

Open another terminal and type following command to inspect IP address. Fluentd is running on this IP address:

```
docker inspect -f '{{.NetworkSettings.IPAddress}}' custom-docker-fluent-logger
```

Let's try to use another docker container to send its logs to Fluentd.

```
docker run --log-driver=fluentd --log-opt fluentd-address=FLUENTD.ADD.RE.SS:24224 python:alpine echo Hello
docker kill -s USR1 custom-docker-fluent-logger
```

(replace `FLUENTD.ADD.RE.SS` with actual IP address you inspected at the previous step)

You will see some logs sent to Fluentd.

### References

[Docker Logging | fluentd.org](http://www.fluentd.org/guides/recipes/docker-logging)

[Fluentd logging driver - Docker Docs](https://docs.docker.com/engine/reference/logging/fluentd/)
