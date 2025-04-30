#!/bin/bash

tooltip="$(cat /tmp/current_tooltip)"

if [ -z "$tooltip" ]; then
    tooltip="$(hyprctl splash)"
fi
echo "$tooltip"
