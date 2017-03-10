#!/usr/bin/dumb-init /bin/sh

uid=${FLUENT_UID:-9001}

# check if a old fluent user exists and delete it
cat /etc/passwd | grep fluent
if [ $? -eq 0 ]; then
    deluser fluent
fi

# (re)add the fluent user with $FLUENT_UID
adduser -D -g '' -u ${uid} -h /home/fluent fluent

# chown data folders
chown -R fluent /home/fluent
chown -R fluent /fluentd

su-exec fluent "$@"
