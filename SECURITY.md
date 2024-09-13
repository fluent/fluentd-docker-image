# Security Policy

## Supported Versions

As same as Fluentd's security policy

See [Supported Versions in Fluentd](https://github.com/fluent/fluentd/blob/master/SECURITY.md)

## Reporting a Vulnerability

If you find a vulnerability of **docker.io/fluent/fluentd:SOMETHING** with the default configuration, report it from the following page:

* https://github.com/fluent/fluentd-docker-image/security/advisories

> [!IMPORTANT]
> fluentd-docker-image images are downstream of [ruby](https://hub.docker.com/_/ruby) or [alpine](https://hub.docker.com/_/alpine) container.
> Thus, even though security scanner reports a pile of vulnerabilities, the updated container image can't be shipped
> until updated container image is deployed from upstream first.

* If you find that bundled Ruby gems related to **fluentd-daemonset-SOMETHING** have vulnerabilities, please report to [fluentd-kubernetes-daemonset](https://github.com/fluent/fluentd-kubernetes-daemonset/issues/new).

* The vulnerability of non-Ruby gems should be fixed in upstream container image, so PLEASE check https://security-tracker.debian.org/tracker/ in advance.

> [!NOTE]
> In most cases, even though security scanner reports vulnerabilities, they are false-positive because fluentd doesn't use the vulnerable component.
