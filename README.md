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

* listen port `24224` for fluentd forward protocol
* store logs with tag `docker.**` into `/fluentd/log/docker.*.log` (and symlink `docker.log`)
* store all other logs into `/fluentd/log/data.*.log` (and symlink data.log)

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

It is very easy to use this image as base image. Write your `Dockerfile` and configuration files, and/or your own plugin files if needed.

```
FROM fluent/fluentd:latest
MAINTAINER your_name <...>
USER fluent
WORKDIR /home/fluent
ENV PATH /home/fluent/ruby/bin:$PATH
RUN gem install fluent-plugin-secure-forward
EXPOSE 24284
CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
```

Files below are automatically included in build process:

`fluent.conf`: used instead of default file
`plugins/*`: copied into `/fluentd/plugins` and loaded at runtime

### Testing

```
docker run --log-driver=fluentd --log-opt fluentd-address=192.168.0.1:24224 IMAGE echo "Hello Fluentd"  
```

Should produce a log-file with `Hello Fluentd`, depending on you `fluent.conf` file.

### References 

[Docker Logging | fluentd.org](http://www.fluentd.org/guides/recipes/docker-logging)

[Fluentd logging driver - Docker Docs](https://docs.docker.com/engine/reference/logging/fluentd/)
