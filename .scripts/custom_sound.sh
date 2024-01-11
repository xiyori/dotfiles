#!/bin/bash

volume="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d':' -f 2 | sed -e 's/\.//' -e 's/ //' -e 's/^0*//')"
nick="$(~/.scripts/default_sink_nick.sh)"

override_icon=0
case $volume in
  *\[MUTED\])
    override_icon=1
    volume="${volume:0: -8}"
  ;;
esac

case $(playerctl status) in 
  Playing)
    text="󰐊 $volume%"
  ;;
  Paused)
    text="󰏤 $volume%"
  ;;
  *)
    if (( volume > 100 )); then
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

if [[ $override_icon -eq 1 ]]; then
    text="󰖁${text:1}"
fi

echo "{\"text\": \"$text\",\"tooltip\":$nick}"
