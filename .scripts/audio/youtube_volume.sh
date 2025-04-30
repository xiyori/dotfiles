#!/bin/bash

title="$(cat /tmp/current_title)"

volume="$(pactl list sink-inputs | awk '/Volume:|media.name / {print $0};' | grep --before-context 1 "$title - YouTube" | head -1 | cut -d "/" -f 3 | cut -d "d" -f 1 | xargs)"

if [ -z "$volume" ]; then
    volume="0.00"
fi

volume="$(bc -l <<< "-($volume)")"

pactl set-sink-volume myeffects_sink "${volume}db"
