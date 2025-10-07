#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
hyprctl keyword monitor "eDP-1,preferred,0x0,1.8"
sleep 2
hyprctl keyword monitor "$monitor,preferred,auto,1,mirror,eDP-1"
echo "{\"text\":\"󰍺 \",\"tooltip\":\"Mirroring to $monitor\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
