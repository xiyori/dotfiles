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
  ;;
  *)
    echo 0 > /tmp/muted
    echo "󰕾  Unmute sound"
  ;;
esac
