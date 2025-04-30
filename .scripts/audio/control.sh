#!/bin/bash

case "$1" in 
  play-pause|next|previous|status|metadata)
    ~/.scripts/audio/player.sh "$1"
  ;;
  *)
    ~/.scripts/audio/volume.sh "$1"
  ;;
esac

pkill -RTMIN+1 waybar
