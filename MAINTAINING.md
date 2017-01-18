How to use and maintain this project
====================================

All operations are automated as much as possible.

- Images and description [on Docker Hub][1] will be automatically rebuilt on
  [pushes to `master` branch][2] and on updates of parent Docker images.
- [Travis CI][3] is used only for tests.
- Generation of each `Dockerfile` and its context is automated via `Makefile`.



## Updating

To update versions of images following steps are required:

1.  Update all required versions in `Makefile`.
2.  Update all required versions in `README.md`.
3.  If you need to modify some `Dockerfile`s then do it via editing
    [`Dockerfile.template.erb` template](Dockerfile.template.erb).
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
