#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
hyprctl eval "hl.monitor({
    output = \"$monitor\",
    mode = \"preferred\",
    position = \"auto\",
    scale = 1,
})"
sleep 2
hyprctl eval 'hl.monitor({
    output = "eDP-1",
    disabled = true,
})'
echo "{\"text\":\"󰶐 \",\"tooltip\":\"$monitor only\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
