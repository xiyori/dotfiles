#!/bin/bash

if ! pactl list clients | grep "Big Meter" > /dev/null 2>&1 ; then
    echo "{\"text\": \"󱄡 N/A\",\"tooltip\":\"Carla not started\"}"
    exit 0
fi

volume="0x$(cat /tmp/loudness)"
volume="$(printf "%d" "$volume")"
volume=$(((volume - 127) / 2 + 90))

tooltip="$(cat /tmp/waybar_tooltip)"

muted="$(cat /tmp/muted)"

if (( volume > 83 )); then
    icon="󰝝"
elif (( volume >= 70 )); then
    icon="󰕾"
elif (( volume >= 60 )); then
    icon="󰖀"
else
    icon="󰕿"
fi

case $(~/.scripts/audio/player.sh status 2> /dev/null) in 
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
