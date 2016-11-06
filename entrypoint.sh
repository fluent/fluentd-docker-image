#!/usr/bin/dumb-init /bin/sh

uid=${FLUENT_UID:-1000}

# check if a old fluent user exists and delete it since alpine 3.4 has no usermod command
cat /etc/passwd | grep fluent
if [[ "${?}" == "0" ]]; then
    deluser fluent
fi

# (re)add the fluent user with $FLUENT_UID
adduser -D -g '' -u ${uid} -h /home/fluent fluent

# chown data folders
chown -R fluent /home/fluent
chown -R fluent /fluentd

gosu fluent fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT "$@"
