#!/bin/bash

 
sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
rsyslogd

# Llamando al ENTRYPOINT predeterminado de la imagen ubuntu/squid
/usr/local/bin/entrypoint.sh -f /etc/squid/squid.conf -NYC
