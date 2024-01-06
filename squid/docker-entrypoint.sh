#!/bin/bash

rsyslogd

# Llamando al ENTRYPOINT predeterminado de la imagen ubuntu/squid
exec /usr/local/bin/entrypoint.sh "$@"
