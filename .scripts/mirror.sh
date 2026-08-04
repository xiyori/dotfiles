#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
if [[ -z "$monitor" ]]; then
  monitor="HDMI-A-1"
fi
hyprctl eval 'hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "0x0",
    scale = 1.8,
})'
sleep 2
hyprctl eval "hl.monitor({
    output = \"$monitor\",
    mode = \"preferred\",
    position = \"auto\",
    scale = 1,
    mirror = \"eDP-1\",
})"
echo "{\"text\":\"󰍺 \",\"tooltip\":\"Mirroring to $monitor\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
