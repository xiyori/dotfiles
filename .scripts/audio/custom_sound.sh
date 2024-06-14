#!/bin/bash

convert_to_json() {
    tmp="$(echo $1 | jq -R .)"
    echo "${tmp:1:-1}"
}


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

artist=$(playerctl metadata 2> /dev/null | grep xesam:artist)
artist="$(convert_to_json "${artist#*artist}")"
title="$(playerctl metadata 2> /dev/null | grep xesam:title)"
title="$(convert_to_json "${title#*title}")"

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

case $(playerctl status 2> /dev/null) in 
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
