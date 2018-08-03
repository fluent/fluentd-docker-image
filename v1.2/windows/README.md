# Fluentd Dockerfile for Windows

```docker
docker run -p 24224:24224 -v c:/dir/to/custom/configs:c:/fluent/config/custom fluentd:windows-1803
```