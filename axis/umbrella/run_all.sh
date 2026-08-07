#!/usr/bin/env sh

FILTER=~/axis/umbrella/sl1th3r_rainbow.sh

echo "==========================================================" | $FILTER
echo "  LAUNCHING AXIS UMBRELLA SUITE -- SL1TH3R 𖤐 RAINBOW COATED " | $FILTER
echo "==========================================================" | $FILTER

# Launch foundational background daemons
~/axis/armature/geofence_sweep.sh &
~/axis/imprint/satellite_bot.sh &
~/axis/umbrella/supervisory_service.sh &
~/axis/sim/ir_pulse_train_symbolic.sh &
~/axis/umbrella/uav_sim.sh 2>&1 | $FILTER &

echo "ALL BACKGROUND DAEMONS, EMITTERS, AND PROCESSES ACTIVE." | $FILTER
