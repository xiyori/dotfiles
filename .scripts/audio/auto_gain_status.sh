#!/bin/bash

[[ "$(cat /tmp/low_latency)" == "low_latency" ]] && exit 0

gain="$(cat /tmp/auto_gain)"
if pgrep "gain_loop.py" > /dev/null 2>&1 ; then
    tooltip="Auto Gain: On"
    icon=""
elif (( $(echo "$gain != 0" | bc -l) )); then
    tooltip="Youtube Gain: On"
    icon="󰗃"
fi
[[ -n "$tooltip" ]] && echo "{\"text\":\"$icon +${gain}db\",\"tooltip\":\"${tooltip}\"}"
