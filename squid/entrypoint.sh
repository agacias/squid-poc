#!/bin/bash

# https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/squid/tree/?h=6.1-23.10
# https://marcelo-ochoa.medium.com/mta-modernize-traditional-apps-with-docker-case-study-1-squid-cluster-45c882921bbc


SIBLING_CONF=/etc/squid/conf.d/sibling.conf
SIBLING_TMP=/var/tmp/sibling.conf

function build_sibling_list() {
  MI_IP=$(tail -1 /etc/hosts|cut -f1)
  echo "# Sibling list" > ${SIBLING_CONF}
  echo "debug_options 9,5 20,9 4,2 ALL,1" >> ${SIBLING_CONF}
  for SERVER in $(dig "tasks.${SERVICE_NAME}" | grep "^tasks\.${SERVICE_NAME}\." | cut -f5 | sort)
  do
     echo "cache_peer ${SERVER} sibling 3128 4827 htcp no-digest" >> ${SIBLING_CONF}
     echo "cache_peer_access ${SERVER} allow all" >> ${SIBLING_CONF}
  done
  sed -i "/cache_peer ${MI_IP}/d" ${SIBLING_CONF}
  sed -i "/cache_peer_access ${MI_IP}/d" ${SIBLING_CONF}


  echo "udp_incoming_address ${MI_IP}" >> ${SIBLING_CONF}
  echo "udp_outgoing_address 255.255.255.255" >> ${SIBLING_CONF}
}

function check_reload_sibling() {
  
  while true
  do
    cp ${SIBLING_CONF} ${SIBLING_TMP}
    build_sibling_list
    if ! diff -q ${SIBLING_TMP} ${SIBLING_CONF}
    then
      echo "Reloading squid after changes in sibling IPs ...."
      squid -k reconfigure
    fi;
    sleep 60s
  done
}


# Initial empty list of siblings
build_sibling_list
check_reload_sibling &


# call entrypoint standard (ubuntu/squid image)
/usr/local/bin/entrypoint.sh -f /etc/squid/squid.conf -NYC
