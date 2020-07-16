#!/bin/bash -x

set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

COMFORT_TEMP=$(cat ${HERE}/../comfort/temperature.txt)

#Update with actual indoor when available
CURR_INDOOR_TEMP=$((COMFORT_TEMP + 1))

if [ "$1" = "comfortcloseup" ]; then
  ${HERE}/comfort.sh ccu_BG &
elif [ "$(echo $1 | cut -d',' -f1)" = "set" ]; then
  echo $1 | cut -d',' -f2 > ${HERE}/../comfort/temperature.txt
elif [ "$1" = "ccu_BG" ]; then
  #Try for 3 hours 36x5minute checks
  for r in {1..36}; do
    W="$(curl "http://api.openweathermap.org/data/2.5/weather?zip=12137,us&appid=ADD_APP_ID_HERE&units=imperial")"
    CURR_OUTDOOR_TEMP=$(echo $W | jq .main.temp)
    #date -u -d @$(($(echo $W | jq .sys.sunrise) + $(echo $W | jq .timezone))) +"%T"
    #date -u -d @$(($(echo $W | jq .sys.sunset) + $(echo $W | jq .timezone))) +"%T"
    if [ $(echo ${CURR_OUTDOOR_TEMP} ${COMFORT_TEMP} | awk '{ printf "%d\n", ($1 > $2); }') -eq 1 ] &&
       [ $(echo ${COMFORT_TEMP} ${CURR_INDOOR_TEMP} | awk '{ printf "%d\n", ($1 >= $2); }') -eq 1 ]; then
      echo "1, Comfort temp of ${COMFORT_TEMP} is between outdoor temp of ${CURR_OUTDOOR_TEMP} and indoor temp of ${CURR_INDOOR_TEMP}, continuing..."
    elif [ $(echo ${CURR_OUTDOOR_TEMP} ${COMFORT_TEMP} | awk '{ printf "%d\n", ($1 < $2); }') -eq 1 ] &&
       [ $(echo ${COMFORT_TEMP} ${CURR_INDOOR_TEMP} | awk '{ printf "%d\n", ($1 <= $2); }') -eq 1 ]; then
      echo "2, Comfort temp of ${COMFORT_TEMP} is between outdoor temp of ${CURR_OUTDOOR_TEMP} and indoor temp of ${CURR_INDOOR_TEMP}, continuing..."
    else
      #text-2-chromecast
      echo "Time to close up the house" | nc 192.168.1.121 22223
      exit 0
    fi
    sleep 300
  done
fi
