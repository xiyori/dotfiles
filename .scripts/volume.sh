#!/bin/bash

case "$1" in 
  up)
    wpctl set-volume -l 1.3 @DEFAULT_AUDIO_SINK@ 5%+
  ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  ;;
  play)
    playerctl play-pause
  ;;
  next)
    playerctl next
  ;;
  prev)
    playerctl previous
  ;;
esac

pkill -RTMIN+1 waybar
