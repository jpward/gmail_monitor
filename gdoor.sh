#!/bin/bash

#gdoor_server
echo "Command gdoor ${1}"

if ! [ -f /tmp/gdoor.lock ]; then
  touch /tmp/gdoor.lock
  curl 192.168.1.121/toggle
  sleep 3
  rm -f /tmp/gdoor.lock
fi
