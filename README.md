Fluentd Docker Image
====================

[![Build Status](https://github.com/fluent/fluentd-docker-image/actions/workflows/linux.yml/badge.svg?branch=master)](https://github.com/fluent/fluentd-docker-image/actions/workflows/linux.yml)
[![Docker Stars](https://img.shields.io/docker/stars/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd)
[![Docker Pulls](https://img.shields.io/docker/pulls/fluent/fluentd.svg)](https://hub.docker.com/r/fluent/fluentd)

## What is Fluentd?

Fluentd is an open source data collector, which lets you unify the data
collection and consumption for a better use and understanding of data.

> [www.fluentd.org](https://www.fluentd.org/)

![Fluentd Logo](https://www.fluentd.org/images/miscellany/fluentd-logo.png)

## Supported tags and respective `Dockerfile` links

### Current images (Edge)

These tags have image version postfix. This updates many places so we need feedback for improve/fix the images.

Current images use fluentd v1 series.

- `v1.19.1-2.0`, `v1.19-2`, `edge`, `latest`
  [(v1.19/debian/Dockerfile)][fluentd-1-debian] (Since v1.19.0, alpine image will not be shipped anymore.)
- `v1.19.1-debian-2.0`, `v1.19-debian-2`, `edge-debian`
  (multiarch image for arm64(AArch64), armhf and amd64(x86_64))
- `v1.19.1-debian-amd64-2.0`, `v1.19-debian-amd64-2`, `edge-debian-amd64`
  [(v1.19/debian/Dockerfile)][fluentd-1-debian]
- `v1.19.1-debian-arm64-2.0`, `v1.19-debian-arm64-2`, `edge-debian-arm64`
  [(v1.19/arm64/debian/Dockerfile)][fluentd-1-debian-arm64]
- `v1.19.1-debian-armhf-2.0`, `v1.19-debian-armhf-2`, `edge-debian-armhf`
  [(v1.19/armhf/debian/Dockerfile)][fluentd-1-debian-armhf]
- `v1.19.1-windows-ltsc2019-1.0`, `v1.19-windows-ltsc2019-1`
  [(v1.19/windows-ltsc2019/Dockerfile)][fluentd-1-ltsc2019-windows]
- `v1.19.1-windows-ltsc2022-1.0`, `v1.19-windows-ltsc2022-1`
  [(v1.19/windows-ltsc2022/Dockerfile)][fluentd-1-ltsc2022-windows]

> [!TIP]
> About deprecated old images, See [DEPRECATED](DEPRECATED.md)

We recommend to use debian version for production because it uses jemalloc to mitigate memory fragmentation issue.

### Using Kubernetes?

Check [fluentd-kubernetes-daemonset](https://github.com/fluent/fluentd-kubernetes-daemonset) images.

## The detail of image tag

This image is based on the popular Debian images and [Alpine Linux project][1], available in
[the alpine official image][2].

### For current images

#### `edge`

Latest released version of Fluentd.

#### `vX.Y-A`

Latest version of `vX.Y` Fluentd branch.

`A` will be incremented when image has major changes.

When fluentd version is updated, A is reset to `1`.

#### `vX.Y.Z-A.B`

Concrete `vX.Y.Z` version of Fluentd. This tag is recommeded for the production environment.

`A` will be incremented when image has major changes.
`B` will be incremented when image has small changes, e.g. library update or bug fixes.

When fluentd version is updated, `A.B` is reset to `1.0`.

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

These tags are obsolete, already removed to avoid confusing.
Use `edge`, `vX.Y-A` or `vX.Y.Z-A.B` images instead.

#### `vX.Y`

Latest version of `vX.Y` Fluentd branch.

#### `vX.Y.Z`

Concrete `vX.Y.Z` version of Fluentd.

#### `onbuild` included tag

`onbuild` images are deprecated. Use non-`onbuild ` images instead to build your image.
New images, v1.5 or later, don't provide `onbuild` version.

#### `debian` included tag, `armhf` included tag

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

`docker run -ti --rm -v /path/to/dir:/fluentd/etc fluent/fluentd -c /fluentd/etc/<conf> -v`

The first `-v` tells Docker to share '/path/to/dir' as a volume and mount it at /fluentd/etc
The `-c` after the container name (fluentd) tells `fluentd` where to find the config file
The second `-v` is passed to `fluentd` to tell it to be verbose

## Change running user

Use `-u` option with `docker run`.

`docker run -p 24224:24224 -u foo -v ...`

## How to build your own image?

Check [HOWTOBUILD](HOWTOBUILD.md) explanation.

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
[fluentd-1-debian]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.19/debian/Dockerfile
[fluentd-1-debian-arm64]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.19/arm64/debian/Dockerfile
[fluentd-1-debian-armhf]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.19/armhf/debian/Dockerfile
[fluentd-1-ltsc2019-windows]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.19/windows-ltsc2019/Dockerfile
[fluentd-1-ltsc2022-windows]: https://github.com/fluent/fluentd-docker-image/blob/master/v1.19/windows-ltsc2019/Dockerfile
