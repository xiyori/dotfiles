#!/bin/bash

volume="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d':' -f 2 | sed -e 's/\.//' -e 's/ //' -e 's/^0*//')"
nick="$(~/.scripts/default_sink_nick.sh)"

artist=$(playerctl metadata | grep xesam:artist)
artist=${artist#*artist}
artist=$(echo $artist | xargs -0)
title=$(playerctl metadata | grep xesam:title)
title=${title#*title}
title=$(echo $title | xargs -0)

if [ "$artist" == "" ]; then
    tooltip="$title"
else
    tooltip="$artist - $title"
fi

if [ "$tooltip" == "" ]; then
    tooltip="$nick"
fi

muted=0

case $volume in
  *\[MUTED\])
    muted=1
    volume="${volume:0: -8}"
  ;;
esac

if (( volume > 100 )); then
    icon="󰝝"
elif (( volume > 60 )); then
    icon="󰕾"
elif (( volume > 20 )); then
    icon="󰖀"
elif (( volume > 0 )); then
    icon="󰕿"
else
    icon="󰝟"
    volume=0
fi

case $(playerctl status) in 
  Playing)
    icon="󰐊"
  ;;
  Paused)
    icon="󰏤"
  ;;
esac

if [[ $muted -eq 1 ]]; then
    icon="󰖁"
fi

echo "{\"text\": \"${icon} ${volume}%\",\"tooltip\":\"$tooltip\"}"
