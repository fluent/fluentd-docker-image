# How to build your own image

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
chmod +x entrypoint.sh

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

About deprecated old images, see [DEPRECATED](DEPRECATED.md).

#### Debian version

```Dockerfile
FROM fluent/fluentd:v1.17-debian-1

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
