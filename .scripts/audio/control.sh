#!/bin/bash

case "$1" in 
  play-pause|next|previous|status|metadata)
    ~/.scripts/audio/player.sh "$1"
  ;;
  *)
    if [ "$(cat /tmp/low_latency)" == "low_latency" ]; then
        ~/.scripts/audio/manual_gain.sh "$1"
    else
        ~/.scripts/audio/volume.sh "$1"
    fi
  ;;
esac

pkill -RTMIN+1 waybar
