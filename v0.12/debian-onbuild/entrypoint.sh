#!/usr/bin/dumb-init /bin/sh

uid=${FLUENT_UID:-9001}

# check if a old fluent user exists and delete it
cat /etc/passwd | grep fluent
if [ $? -eq 0 ]; then
    deluser fluent
fi

# (re)add the fluent user with $FLUENT_UID
useradd -u ${uid} -o -c "" -m fluent
export HOME=/home/fluent

# chown data folders
chown -R fluent /home/fluent
chown -R fluent /fluentd

gosu fluent "$@"
