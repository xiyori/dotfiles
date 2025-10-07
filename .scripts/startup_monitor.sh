#!/bin/bash

for i in {1..60}; do
    if hyprctl monitors | grep -q "Monitor DP-"; then
        hyprctl keyword monitor "eDP-1,disable"
        # break
    fi
    sleep 1
done
