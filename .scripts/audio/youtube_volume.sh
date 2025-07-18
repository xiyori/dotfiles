#!/bin/bash

# title="$(cat /tmp/current_title)"

volume="$(pactl list sink-inputs | awk '/Corked:|Volume:|media.name / {print $0};' | grep --after-context 2 "Corked: no" | grep --before-context 1 " - YouTube" | head -1 | cut -d "/" -f 3 | cut -d "d" -f 1 | xargs)"

if [ -z "$volume" ]; then
    volume="0.00"
fi

volume="$(bc -l <<< "-($volume)")"

if ! pgrep "gain_loop.sh" > /dev/null 2>&1 ; then
    pactl set-sink-volume gain_sink "${volume}db"
fi
