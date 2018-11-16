#!/usr/bin/dumb-init /bin/sh

#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    source $DEFAULT
    set +o allexport
fi

exec gosu fluent "$@"
