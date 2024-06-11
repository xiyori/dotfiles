#!/bin/bash

if ! pactl list clients | grep "LSP Loudness Compensator Stereo" > /dev/null 2>&1; then
    echo "{\"text\": \"󱄡 N/A\",\"tooltip\":\"Carla not started\"}"
    exit 0
fi

~/.scripts/audio/detect_sink_change.sh

volume="0x$(cat /tmp/loudness)"
volume="$(printf "%d" "$volume")"
volume=$(((volume - 127) / 2 + 90))
sink="$(~/.scripts/audio/get_active_sink.sh)"
nick="$(~/.scripts/audio/active_sink_nick.sh)"

artist=$(playerctl metadata > /dev/null 2>&1 | grep xesam:artist)
artist=${artist#*artist}
artist=$(echo $artist | xargs -0)
title=$(playerctl metadata > /dev/null 2>&1 | grep xesam:title)
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

case "$(pactl get-sink-mute "$sink")" in
  *yes)
    muted=1
  ;;
esac

if (( volume > 83 )); then
    icon="󰝝"
elif (( volume >= 70 )); then
    icon="󰕾"
elif (( volume >= 60 )); then
    icon="󰖀"
else
    icon="󰕿"
fi

case $(playerctl status > /dev/null 2>&1) in 
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

echo "{\"text\": \"${icon} ${volume}db\",\"tooltip\":\"$tooltip\"}"
