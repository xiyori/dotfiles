#!/bin/bash

case "$1" in 
  play-pause|next|previous|status|metadata)
    ~/.scripts/audio/player.sh "$1"
    exit 0
  ;;
  mute)
    for active_sink in $(~/.scripts/audio/list_active_sinks.sh) ; do
        pactl set-sink-mute "$active_sink" toggle
    done
    case "$(pactl get-sink-mute "$active_sink")" in
      *yes)
        echo 1 > /tmp/muted
      ;;
      *)
        echo 0 > /tmp/muted
      ;;
    esac
  ;;
  *)
    if [[ "$(cat /tmp/low_latency)" == "low_latency" ]]; then
        ~/.scripts/audio/bypass_volume.sh "$1"
    else
        ~/.scripts/audio/volume.sh "$1"
    fi
  ;;
esac

pkill -RTMIN+1 waybar
