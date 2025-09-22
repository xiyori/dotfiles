#!/bin/bash

[[ "$(cat /tmp/low_latency)" == "low_latency" ]] && exit 0

if [[ "$1" == "reset" ]]; then
    killall "gain_loop.py"
    killall "youtube_gain.sh"
    killall amidi

    echo 0 > /tmp/auto_gain
    notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Auto Gain: Reset"

    device="$(~/.scripts/audio/midi_device.sh)"
    amidi -p "$device" -d | ~/.scripts/audio/gain_loop.py
elif (( "$(echo "$(cat /tmp/auto_gain) != 0" | bc -l)" )) || pgrep "gain_loop.py" > /dev/null 2>&1 ; then
    killall "gain_loop.py"
    killall amidi
    # amidi -p "$device" -S "B1 07 00"
    pactl set-sink-volume myeffects_sink 100%
    echo 0 > /tmp/auto_gain

    notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Auto Gain: Off"
else
    killall "youtube_gain.sh"

    echo 0 > /tmp/auto_gain
    notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Auto Gain: On"

    device="$(~/.scripts/audio/midi_device.sh)"
    amidi -p "$device" -d | ~/.scripts/audio/gain_loop.py
fi

pkill -RTMIN+2 waybar
