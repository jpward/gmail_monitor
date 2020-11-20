#!/bin/bash -x

set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

HTML=false
TXT="$1"
echo $TXT | grep "&.*;" && HTML=true
if $HTML; then
  TXT="$(echo $TXT | python3 -c 'import html, sys; [print(html.unescape(l), end="") for l in sys.stdin]')"
fi

TXT="$(echo $TXT | sed "s/ ' /'/")"
#yt-2-chromecast
echo "$TXT" | nc 192.168.1.11 22224
