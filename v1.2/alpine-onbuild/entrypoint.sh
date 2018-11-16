#!/usr/bin/dumb-init /bin/sh

if [ -r $DEFAULT ]; then
    set -o allexport
    source $DEFAULT
    set +o allexport
fi

exec su-exec fluent "$@"
