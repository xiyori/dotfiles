#!/bin/bash

[[ "$(cat /tmp/low_latency)" == "low_latency" ]] && exit 0

gain="$(cat /tmp/auto_gain)"
if [[ "$(cat /tmp/auto_gain_enabled)" -eq 1 ]] ; then
    tooltip="Auto Gain: On"
    icon="󱄠"
elif (( $(echo "$gain != 0" | bc -l) )); then
    tooltip="Youtube Gain: On"
    icon="󰗃"
fi
if (( "$(echo "$gain >= 0" | bc -l)" )); then
    gain="+$gain"
fi
[[ -n "$tooltip" ]] && echo "{\"text\":\"$icon ${gain}db\",\"tooltip\":\"${tooltip}\"}"
