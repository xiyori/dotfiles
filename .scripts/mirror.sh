#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
if [[ -z "$monitor" ]]; then
  monitor="HDMI-A-1"
fi
hyprctl eval 'hl.monitor({
    output = "eDP-1",
    disabled = false
})'
sleep 2
hyprctl eval "hl.monitor({
    output = \"$monitor\",
    mirror = \"eDP-1\",
    disabled = false
})"
echo "{\"text\":\"󰍺 \",\"tooltip\":\"Mirroring to $monitor\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
