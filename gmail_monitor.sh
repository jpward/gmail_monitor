#!/bin/bash

set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

work() {
  if ! [ -f /tmp/.meta ]; then
    cp $HERE/.meta /tmp/.meta
  fi

  TOK="`cat /tmp/.meta | head -1`"
  RTOK="`cat /tmp/.meta | tail -1`"
  curl -s -H "Authorization: Bearer $TOK" "https://www.googleapis.com/gmail/v1/users/me/threads?q=from:me+OR+from:action@ifttt.com;label:unread" > /tmp/curl.txt

  if ! [ -z "`grep '"message": "Invalid Credentials",' /tmp/curl.txt`" ]; then
    echo woot
    TMSG="`curl -X POST https://www.googleapis.com/oauth2/v4/token \
      --header "Content-Type: application/x-www-form-urlencoded" \
      -d "client_id=<ENTER_CLIENT_ID_HERE!!!>" \
      -d "client_secret=<ENTER_SECRET_HERE!!!>" \
      -d "refresh_token=$RTOK" \
      -d "grant_type=refresh_token"`"
      TOK="`echo $TMSG | cut -d',' -f1 | sed 's/{ \"access_token\": \"\(.*\)\"/\1/'`"
      if ! [ -z "$TOK" ]; then
        echo $TOK > /tmp/.meta
        echo $RTOK >> /tmp/.meta
        curl -s -H "Authorization: Bearer $TOK" "https://www.googleapis.com/gmail/v1/users/me/threads?q=from:me;label:unread" > /tmp/curl.txt
     fi
  fi

  # Get rid of IFTTT junk at end of email, needed for new email me function
  #MSG="`grep -C1 -m1 aut0m8 /tmp/curl.txt | sed 's/ If You say \&quot;.*",$/",/' || echo ""`"
  MSG="`grep -C1 -m1 aut0m8 /tmp/curl.txt | sed 's/:3nd.*",/",/' || echo ""`"

  if [ -z "$MSG" ]; then
    return
  fi
  echo $MSG

  ID="`echo $MSG | cut -d',' -f1 | sed 's/\"id\": \"\(.*\)\"/\1/'`"
  CMD="`echo $MSG | cut -d',' -f2 | sed 's/\"snippet\": \"\(.*\)\"/\1/'`"

  SCRIPT_PLUS_INPUT="`echo $CMD | cut -d':' -f2- | sed -e 's/:/ /'`"
  SCRIPT="`echo ${SCRIPT_PLUS_INPUT} | cut -d' ' -f1 | tr 'A-Z' 'a-z'`"
  INPUT="`echo ${SCRIPT_PLUS_INPUT} | cut -d' ' -f2-`"

  curl -H "Authorization: Bearer $TOK" https://www.googleapis.com/gmail/v1/users/me/threads/$ID/trash -X POST --header "Content-length:0" &
  if [ -a $HERE/${SCRIPT}.sh ]; then
    $HERE/${SCRIPT}.sh "$INPUT"
  else
    $HERE/repeat.sh "${SCRIPT} not a valid command, did you mean play ${SCRIPT}?"
  fi
}

RUN=true
while $RUN; do
  work
  sleep 1
done
