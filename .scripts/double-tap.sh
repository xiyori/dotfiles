#!/usr/bin/env bash

# Requires: libinput-tools, ydotool (must have ydotoold running as root)

DEVICE_NAME="ELAN2514:00 04F3:43EF"   # change to your touchscreen device name
DOUBLE_TAP_THRESHOLD=0.3         # seconds between taps for a double tap
DISTANCE_THRESHOLD=50              # mm^2 distance between taps
YDOTOOL_SOCKET="/tmp/.ydotool_socket"

# Get the device id for the touchscreen
DEVICE_ID=$(libinput list-devices | awk -v dev="$DEVICE_NAME" '
    $0 ~ dev {found=1}
    found && /event/ {print $NF; exit}')

if [[ -z "$DEVICE_ID" ]]; then
    echo "Touchscreen device not found: $DEVICE_NAME"
    exit 1
fi

last_tap_time=0
first_x=0
first_y=0

libinput debug-events --device "$DEVICE_ID" | \
while read -r line; do
    # Look for "DOWN" events (finger touch)
    if echo "$line" | grep -q "TOUCH_DOWN"; then
        coords="$(echo "$line" | awk '{print $7}' | tr -d '()m')"
        x="$(echo "$coords" | cut -d '/' -f 1)"
        y="$(echo "$coords" | cut -d '/' -f 2)"

        now=$(date +%s.%N)
        elapsed=$(echo "$now - $last_tap_time" | bc)
        distance="$(echo "($x - $first_x) ^ 2 + ($y - $first_y) ^ 2" | bc -l)"
        if (( $(echo "$elapsed < $DOUBLE_TAP_THRESHOLD" | bc -l) )) && (( $(echo "$distance < $DISTANCE_THRESHOLD" | bc -l) )); then
            # Double tap detected -> trigger double click
            ydotool click --repeat 2 --next-delay 25 0xC0
            last_tap_time=0   # reset
        else
            last_tap_time=$now
            first_x="$x"
            first_y="$y"
        fi
    # elif echo "$line" | grep -q "TOUCH_MOTION"; then
    #     coords="$(echo "$line" | awk '{print $7}' | tr -d '()m')"
    #     now_x="$(echo "$coords" | cut -d '/' -f 1)"
    #     now_y="$(echo "$coords" | cut -d '/' -f 2)"
    fi
done
