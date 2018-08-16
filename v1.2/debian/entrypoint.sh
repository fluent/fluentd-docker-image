#!/usr/bin/dumb-init /bin/sh

uid=${FLUENT_UID:-1000}

#source vars from /etc/default/fluentd
DEFAULT=/etc/default/fluent

if [ -r $DEFAULT ]; then
    set -o allexport
    source $DEFAULT
    set +o allexport
fi

# check if a old fluent user exists and delete it
cat /etc/passwd | grep fluent
if [ $? -eq 0 ]; then
    deluser fluent
fi

# (re)add the fluent user with $FLUENT_UID
useradd -u ${uid} -o -c "" -m fluent
export HOME=/home/fluent

# chown home and data folder
chown -R fluent /home/fluent
chown -R fluent /fluentd

exec gosu fluent "$@"
