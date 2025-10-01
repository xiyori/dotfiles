#!/bin/bash

if [[ -z "$1" ]]; then
    active_sink="$(~/.scripts/audio/get_active_sink.sh)"
else
    active_sink="$1"
fi
case "$(pactl get-sink-mute "$active_sink")" in
  *yes)
    echo 1 > /tmp/muted
    echo "󰖁  Mute sound"
    eww_icon="󰕾"
  ;;
  *)
    echo 0 > /tmp/muted
    icon="$(~/.scripts/audio/volume_icon.sh)"
    echo "$icon  Unmute sound"
    eww_icon="󰖁"
  ;;
esac
[[ "$(cat /tmp/tablet_mode)" -eq 1 ]] && eww update mute_icon="$eww_icon"
