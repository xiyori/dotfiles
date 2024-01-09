#!/bin/bash

volume="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d':' -f 2 | sed -e 's/\.//' -e 's/ //' -e 's/^0*//')"
nick="$(~/.scripts/default_sink_nick.sh)"

case $(playerctl status) in 
  Playing)
    text="󰐊 $volume%"
  ;;
  Paused)
    text="󰏤 $volume%"
  ;;
  *)
    if [[ "$volume" =~ .*\[MUTED\] ]]; then
      text="󰖁 "
    elif (( volume > 100 )); then
      text="󰝝 $volume%"
    elif (( volume > 60 )); then
      text="󰕾 $volume%"
    elif (( volume > 20 )); then
      text="󰖀 $volume%"
    elif (( volume > 0 )); then
      text="󰕿 $volume%"
    else
      text="󰝟 "
    fi
esac

echo "{\"text\": \"$text\",\"tooltip\":$nick}"
