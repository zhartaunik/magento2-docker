#!/bin/bash

set -e

exec varnishd \
    -j unix,user=vcache \
    -F \
    -f ${VARNISH_CONFIG} \
    -s ${VARNISH_STORAGE} \
    -a ${VARNISH_LISTEN} \
    -T ${VARNISH_MANAGEMENT_LISTEN} \
    -p feature=+esi_ignore_https \
    ${VARNISH_DAEMON_OPTS}
