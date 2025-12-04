# The detail of image tag

This image is based on the popular Debian images and [Alpine Linux project][1], available in
[the alpine official image][2].

## For current images

### `edge`

Latest released version of Fluentd.

### `vX.Y-A`

Latest version of `vX.Y` Fluentd branch.

`A` will be incremented when image has major changes.

When fluentd version is updated, A is reset to `1`.

### `vX.Y.Z-A.B`

Concrete `vX.Y.Z` version of Fluentd. This tag is recommeded for the production environment.

`A` will be incremented when image has major changes.
`B` will be incremented when image has small changes, e.g. library update or bug fixes.

When fluentd version is updated, `A.B` is reset to `1.0`.

### `debian` included tag

The image based on [Debian Linux image][7].
You may use this image when you require plugins which cannot be installed on Alpine (like `fluent-plugin-systemd`).

### `armhf` included tag

The `armhf` images use ARM base images for use on devices such as Raspberry Pis.

Furthermore, the base images enable support for cross-platform builds using the cross-build tools from [resin.io](https://docs.resin.io/reference/base-images/resin-base-images/#resin-xbuild-qemu).

In order to build these images natively on ARM devices, the `CROSS_BUILD_START` and `CROSS_BUILD_END` Docker build arguments must be set to the shell no-op (`:`), for example:
```bash
docker build --build-arg CROSS_BUILD_START=":" --build-arg CROSS_BUILD_END=":" -t fluent/fluentd:v1.3-onbuild-1 v1.3/armhf/alpine-onbuild
```
(assuming the command is run from the root of this repository).

## For older images

These images/tags are kept for backward compatibility. No update anymore and don't use for new deployment. Use "current images" instead.

#### `stable`, `latest`

These tags are obsolete, already removed to avoid confusing.
Use `edge`, `vX.Y-A` or `vX.Y.Z-A.B` images instead.

### `vX.Y`

Latest version of `vX.Y` Fluentd branch.

### `vX.Y.Z`

Concrete `vX.Y.Z` version of Fluentd.

### `onbuild` included tag

`onbuild` images are deprecated. Use non-`onbuild ` images instead to build your image.
New images, v1.5 or later, don't provide `onbuild` version.

### `debian` included tag, `armhf` included tag

Same as current images.
