#!/bin/bash

if [[ "$1" == "reset" ]]; then
    killall "gain_loop.sh"
    killall amidi

    if [ ! -f /tmp/auto_gain ]; then
        echo 0 > /tmp/auto_gain
    fi
    notify-send --expire-time 3000 "Auto Gain: Reset"

    ~/.scripts/audio/gain_loop.sh
elif pgrep "gain_loop.sh" > /dev/null 2>&1 ; then
    killall "gain_loop.sh"
    killall amidi
    # device="$(~/.scripts/audio/midi_device.sh)"
    # amidi -p "$device" -S "B1 07 00"
    pactl set-sink-volume gain_sink 100%
    echo 0 > /tmp/auto_gain

    notify-send --expire-time 3000 "Auto Gain: Off"
else
    echo 0 > /tmp/auto_gain
    notify-send --expire-time 3000 "Auto Gain: On"

    ~/.scripts/audio/gain_loop.sh
fi

pkill -RTMIN+2 waybar
