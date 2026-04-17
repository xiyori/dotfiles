#!/bin/bash

muted="$1"
echo "$muted" > /tmp/muted

[[ "$(cat /tmp/tablet_mode)" -eq 1 ]] || exit

if [[ "$muted" -eq 1 ]]; then
  eww_icon="󰕾"
else
  eww_icon="󰖁"
fi
eww update mute_icon="$eww_icon"
