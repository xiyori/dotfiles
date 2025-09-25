#!/bin/bash

[[ "$(cat /tmp/low_latency)" == "low_latency" ]] && exit 0

if [[ "$1" == "reset" ]]; then
    killall "gain_loop.py"
    killall "youtube_gain.sh"
    killall amidi

    # echo 0 > /tmp/auto_gain
    echo 1 > /tmp/auto_gain_enabled
    notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Auto Gain: Reset"
    # pkill -RTMIN+2 waybar

    device="$(~/.scripts/audio/midi_device.sh)"
    amidi -p "$device" -d | ~/.scripts/audio/gain_loop.py
elif [[ "$(cat /tmp/auto_gain_enabled)" -eq 1 ]] ; then
    killall "gain_loop.py"
    killall amidi
    # amidi -p "$device" -S "B1 07 00"
    pactl set-sink-volume myeffects_sink 100%

    echo 0 > /tmp/auto_gain
    echo 0 > /tmp/auto_gain_enabled
    notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Auto Gain: Off"

    ~/.scripts/audio/youtube_gain.sh &
elif (( "$(echo "$(cat /tmp/auto_gain) != 0" | bc -l)" )); then
    pactl set-sink-volume myeffects_sink 100%
    echo 0 > /tmp/auto_gain
    echo 0 > /tmp/auto_gain_enabled
    notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Youtube Gain: Off"
else
    killall "youtube_gain.sh"

    echo 0 > /tmp/auto_gain
    echo 1 > /tmp/auto_gain_enabled
    notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Auto Gain: On"
    pkill -RTMIN+2 waybar

    device="$(~/.scripts/audio/midi_device.sh)"
    amidi -p "$device" -d | ~/.scripts/audio/gain_loop.py
fi

pkill -RTMIN+2 waybar
