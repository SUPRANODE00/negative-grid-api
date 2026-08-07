#!/usr/bin/env sh
AUDIT_LOG=~/axis/imprint/witness.log
MQTT_TOPIC="mesh/uav/sim/ir_telemetry"
COMPLIANCE="SECTION_508_ACCESSIBLE"
Origin=0
Sweep=0
Capsule=0
Sequence_ID=1
echo "=========================================================="
echo " [AXIS] IR Pulse Train Symbolic Simulator Active"
echo " Monitoring Continuity: [Origin:Sweep:Capsule]"
echo " Duality State: approach (+), oscillation (~), separation (-)"
echo " AC (Continuous Stream) / DC (Discrete Pulse)"
echo "=========================================================="
while :; do
  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  Modulos=$(( Sequence_ID % 3 ))
  case $Modulos in
    0) Duality="approach"; Polarity="+"; Capsule=$((Capsule + 1)) ;;
    1) Duality="oscillation"; Polarity="~"; Sweep=$((Sweep + 1)) ;;
    2) Duality="separation"; Polarity="-"; Origin=$((Origin + 1)) ;;
  esac
  AC_DC_Mod=$(( Sequence_ID % 2 ))
  if [ $AC_DC_Mod -eq 0 ]; then
    AC_DC="AC"
    Pulse="11111111111111111111111111111111"
  else
    AC_DC="DC"
    Pulse="10101100101011001010110010101100"
  fi
  State_Hash=$(echo -n "${TS}:${Polarity}:${AC_DC}:${Pulse}" | sha256sum | awk '{print $1}')
  JSON_PAYLOAD=$(cat <<JSON
{
  "timestamp": "$TS",
  "device": "IR_REMOTE_01",
  "sequence_id": $Sequence_ID,
  "telemetry": {
    "pulse_train": "$Pulse",
    "polarity": "$Polarity",
    "duality": "$Duality",
    "acdc": "$AC_DC",
    "synergy_hash": "$State_Hash"
  },
  "trinity": { "origin": $Origin, "sweep": $Sweep, "capsule": $Capsule },
  "compliance": "$COMPLIANCE"
}
JSON
  )
  echo "[IR-AUDIT] $TS | ID=$Sequence_ID | Trinity=$Origin:$Sweep:$Capsule | Duality=$Polarity:$AC_DC | Hash=$State_Hash" >> $AUDIT_LOG
  if command -v mosquitto_pub >/dev/null 2>&1; then
    echo "$JSON_PAYLOAD" | mosquitto_pub -t "$MQTT_TOPIC" -l
  fi
  Sequence_ID=$((Sequence_ID + 1))
  sleep 5
done
