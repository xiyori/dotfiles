#!/bin/bash

for i in {1..30}; do
    if niri msg outputs | grep -q -F "(DP-1)"; then
        niri msg output eDP-1 off
        # break
    fi
    sleep 1
done
