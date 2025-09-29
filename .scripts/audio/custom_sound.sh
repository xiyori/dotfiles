#!/bin/bash

if ! pactl list clients | grep "LSP Loudness Compensator Stereo" > /dev/null 2>&1 ; then
    echo "{\"text\": \"󱄡 N/A\",\"tooltip\":\"Carla not started\"}"
    exit 0
fi

muted="$(cat /tmp/muted)"
player_status="$(cat /tmp/player_status)"
volume="$(cat /tmp/loudness)"

if (( muted == 1 )); then
    icon="󰖁"
elif (( player_status == 1 )); then
    icon="󰐊"
elif (( player_status == 2 )); then
    icon="󰏤"
else
    icon="$(~/.scripts/audio/volume_icon.sh)"
fi

metadata="$(cat /tmp/player_metadata)"
nick="$(cat /tmp/active_sink_nick)"
if [[ -z "$metadata" ]]; then
    tooltip="$nick"
else
    tooltip="${metadata:1:-1}"
fi

echo "{\"text\": \"${icon} ${volume}db\",\"tooltip\":\"$tooltip\"}"
