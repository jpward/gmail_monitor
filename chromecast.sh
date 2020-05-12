#!/bin/bash -x

set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

#text-2-chromecast
echo "$1" | nc 192.168.1.121 22223
