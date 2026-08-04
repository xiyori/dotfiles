#!/bin/bash

for i in {1..30}; do
    if hyprctl monitors | grep -q -E "Monitor (HDMI-A-|DP-1)"; then
        hyprctl eval 'hl.monitor({
            output = "eDP-1",
            disabled = true,
        })'
        # break
    fi
    sleep 1
done
