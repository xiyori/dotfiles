#!/usr/bin/env bash

DEVICE_NAME="Intel HID switches"

touch /tmp/tablet_switch

while read -r line; do
    if echo "$line" | grep -q "DEVICE_ADDED" && echo "$line" | grep -q "$DEVICE_NAME"; then
        device_id="$(echo "$line" | awk '{print $1}' | tr -d '-')"
        break
    fi
done < <(libinput debug-events)

DEVICE="/dev/input/$device_id"
libinput debug-events --device "$DEVICE" | \
while read -r line; do
    if echo "$line" | grep -q "tablet"; then
        echo "$line" >> /tmp/tablet_switch
    fi
done
