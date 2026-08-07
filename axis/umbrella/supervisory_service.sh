#!/usr/bin/env sh
RAW_INPUT=~/axis/armature/geofence_state.txt
AUDIT_LOG=~/axis/imprint/witness.log
MQTT_TOPIC="mesh/uav/supervisory/beacon"
CAPSULE_ID="CAPSULE-OMEGA"
FILTER=~/axis/umbrella/sl1th3r_rainbow.sh
echo "[SUPERVISORY CONTROL TOWER] Encapsulating with SL1TH3R 𖤐 RAINBOW INFERNAL BURNMARK..." | $FILTER
while :; do
  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  LAT=$(awk '{print $1}' $RAW_INPUT 2>/dev/null)
  LON=$(awk '{print $2}' $RAW_INPUT 2>/dev/null)
  LAT=${LAT:-30.388412}
  LON=${LON:-96.088295}
  GATE_STATUS="PERMITTED"
  if [ -f ~/axis/armature/lockout.flag ]; then
    GATE_STATUS="GATED_HALT"
  fi
  BURNMARK=$(echo -n "${TS}:${CAPSULE_ID}:${LAT}:${LON}:${GATE_STATUS}:SL1TH3R_RAINBOW" | sha256sum | awk '{print $1}')
  JSON_PAYLOAD=$(cat <<JSON
{
  "timestamp": "$TS",
  "capsule_id": "$CAPSULE_ID",
  "gate_status": "$GATE_STATUS",
  "spectrum": "SL1TH3R_RAINBOW",
  "infernal_burnmark": "$BURNMARK",
  "compliance": "SECTION_508_ACCESSIBLE",
  "coordinates": { "lat": $LAT, "lon": $LON }
}
JSON
  )
  if [ "$GATE_STATUS" = "PERMITTED" ]; then
    echo "[AUDIT] $TS | CAPSULE=$CAPSULE_ID | BURNMARK=$BURNMARK | STATE=$GATE_STATUS" >> $AUDIT_LOG
    if command -v mosquitto_pub >/dev/null 2>&1; then
      echo "$JSON_PAYLOAD" | mosquitto_pub -t "$MQTT_TOPIC" -l
    fi
    echo "EMITTED BEACON: $TS | BURNMARK: ${BURNMARK:0:16}... | GATE: $GATE_STATUS" | $FILTER
  else
    echo "GATED EXECUTION NOTICE: $TS" | $FILTER
  fi
  sleep 5
done
