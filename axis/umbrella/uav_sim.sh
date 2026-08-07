#!/usr/bin/env sh
TOPIC="mesh/uav/sim/red_eye"
while :; do
  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  LAT=$(awk '{print $1}' ~/axis/armature/geofence_state.txt 2>/dev/null)
  LON=$(awk '{print $2}' ~/axis/armature/geofence_state.txt 2>/dev/null)
  echo "[UAV-SIM] ts=$TS lat=${LAT:-30.388412} lon=${LON:-96.088295} capsule=CAPSULE-OMEGA" | mosquitto_pub -t "$TOPIC" -l 2>/dev/null || true
  sleep 5
done
