#!/bin/bash

case "$1" in 
  play)
    playerctl play-pause
  ;;
  next)
    playerctl next
  ;;
  prev)
    playerctl previous
  ;;
  *)
    ~/.scripts/audio/volume.sh "$1"
  ;;
esac

pkill -RTMIN+1 waybar
