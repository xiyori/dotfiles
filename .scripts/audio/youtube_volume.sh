#!/bin/bash

volume="$(pactl get-sink-volume myeffects_sink | ~/.scripts/audio/get_pactl_volume.sh)"
new_volume="$(pactl list sink-inputs | awk '/Corked:|Volume:|media.name / {print $0};' | grep --after-context 2 "Corked: no" | grep --before-context 1 " - YouTube" | ~/.scripts/audio/get_pactl_volume.sh)"

if [[ -z "$new_volume" ]]; then
    new_volume="0"
fi

new_volume="$(bc -l <<< "-($new_volume)")"

if ! pgrep "gain_loop.sh" > /dev/null 2>&1 && (( $(echo "$volume != $new_volume" | bc -l) )); then
    pactl set-sink-volume myeffects_sink "${new_volume}db"
    echo "$new_volume" > /tmp/auto_gain
    pkill -RTMIN+2 waybar
fi
