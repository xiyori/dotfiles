#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
hyprctl eval "hl.monitor({
    output = \"$monitor\",
    disabled = false,
    mirror = ""
})"
sleep 2
hyprctl eval 'hl.monitor({
    output = "eDP-1",
    disabled = true,
})'
echo "{\"text\":\"󰶐 \",\"tooltip\":\"$monitor only\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
