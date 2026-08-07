#!/usr/bin/env sh
RAINBOW_CODES="196 202 208 214 220 226 190 154 118 82 46 48 51 45 39 27 33 63 99 135 171 207 201 198"
sl1th3r_colorize() {
  LINE="$1"
  LEN=${#LINE}
  OUT=""
  C_IDX=0
  set -- $RAINBOW_CODES
  NUM_COLORS=$#
  i=0
  while [ $i -lt $LEN ]; do
    CHAR=$(echo "$LINE" | cut -c $((i+1)))
    COLOR_VAL=$(eval echo \$$(( (C_IDX % NUM_COLORS) + 1 )))
    OUT="${OUT}\033[38;5;${COLOR_VAL}m${CHAR}"
    C_IDX=$((C_IDX + 1))
    i=$((i + 1))
  done
  printf "${OUT}\033[0m\n"
}
if [ ! -t 0 ]; then
  while IFS= read -r input_line; do
    sl1th3r_colorize "𖤐 [SL1TH3R] $input_line"
  done
fi
