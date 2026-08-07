#!/usr/bin/env sh
POS_FILE=~/axis/armature/geofence_state.txt
BASE_LAT=30.388412
BASE_LON=-96.088295
while :; do
  JITTER=$(awk 'BEGIN{srand(); print (rand()-0.5)*0.0009}')
  NEW_LAT=$(awk "BEGIN {print $BASE_LAT + $JITTER}")
  NEW_LON=$(awk "BEGIN {print $BASE_LON + $JITTER}")
  echo "$NEW_LAT $NEW_LON" > $POS_FILE
  sleep 5
done
