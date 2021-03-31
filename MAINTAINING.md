How to use and maintain this project
====================================

All operations are automated as much as possible.

- [Travis CI][3] is used only for tests.
- Generation of each `Dockerfile` and its context is automated via `Makefile`.



## Updating

To update versions of images following steps are required:

1.  Update all required versions in `Makefile`.
2.  Update all required versions in `README.md`.
3.  Edit templates
    1.  If you need to modify some `Dockerfile`s then do it via editing
        [`Dockerfile.template.erb`](Dockerfile.template.erb).
    2.  If you need to modify some `fluent.conf`s then do it via editing
        [`fluent.conf.erb`](fluent.conf.erb)
4.  Regenerate all `Dockerfile`s and their context (it's okay to remove previous
    ones completely):
    ```bash
    make src-all
    ```
5.  If `Dockerfile`s layout was changed somehow (major version change, for
    example), you should check [build triggers on Docker Hub][2] and
    [Travis CI configuration](.travis.yml), modify them as required
    BEFORE push to `master` branch.
6.  Push changes to `master` branch.


### Image versioning convensions

1. We use the following image versioning convension:
    1. `v<Fluentd version>-[debian|windows-<windows version>]-[arm64(for aarch64 image)]-<image major version>.<image minor version>`
        1. `[]` parts can be omitted in some situations:
        2. alpine image does not use distribution name: `v<Fluentd version>-<image major version>.<image minor version>`
        3. architecture name can be omitted on `x86_64`. For AArch64, it must add in the image version. e.g. `v<Fluentd version>-debian-arm64-<image major version>.<image minor version>`
    2. Reset image version to `1.0` when bump up Fluentd version
    3. Bump up image major version when including breaking changes on a destination
    4. Bump up image minor version when updating gems on a destination

## Publish Images

**Note:** This procedure requires `fluent/fluentd` repository's DockerHub `Admin` privileges.

Go to [Build settings page](https://hub.docker.com/repository/docker/fluent/fluentd/builds) and then, push `[Trigger ▷]` buttons.

Built tags for debian and alpine images will be published at [TAGS page](https://hub.docker.com/r/fluent/fluentd-kubernetes-daemonset/tags).

### Build and Publish Windows Server Core images

#### Prerequisites

* Windows 10 Pro
* Docker Desktop for Windows
* MSYS2 (only for `make` command)
* RubyInstaller (only for `ridk` command)
* Already logined in DockerHub via `docker login`

#### Build procedures

```console
PS> ridk enable
PS> make DOCKERFILE=<Fluentd version>/windows-<windows version> VERSION=v<Fluentd version>-windows-<Windows version>-1.0
PS> docker push fluent/fluentd:v<Fluentd version>-windows-<Windows version>-1.0
PS> make DOCKERFILE=<Fluentd version>/windows-<windows version> VERSION=v<Fluentd version without patchversion>-windows-<Windows version>-1
PS> docker push fluent/fluentd:v<Fluentd version without patchversion>-windows-<Windows version>-1
```

##### CommandLine Example

Building Fluentd v1.12.2 and Windows Server Core 2004 image:

```console
PS> ridk enable
PS> make DOCKERFILE=v1.12/windows20H2 VERSION=v1.12.2-windows-20H2-1.0
PS> docker push fluent/fluentd:v1.12.2-windows-20H2-1.0
PS> make DOCKERFILE=v1.12/windows-20H2 VERSION=v1.12-windows-20H2-1
PS> docker push fluent/fluentd:v1.12-windows-20H2-1
```

## Testing

To run tests for all possible image versions, just do:
```bash
make test-all prepare-images=yes
```

It will build images for each `Dockerfile` and run those images against
[`test/suite.bats`](test/suite.bats).



## Manual release

It's still possible to build, tag and push images manually.
Just use:
```bash
make release-all
```

It will build all existing `Dockerfile`s, tag them with proper tags
([as `README.md` requires][4]) and push them to Docker Hub.





[1]: https://hub.docker.com/r/fluent/fluentd/tags
[2]: https://hub.docker.com/r/fluent/fluentd/~/settings/automated-builds
[3]: https://travis-ci.org/fluent/fluentd-docker-image
[4]: README.md#supported-tags-and-respective-dockerfile-links
