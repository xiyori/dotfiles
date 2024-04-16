#!/bin/bash

hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
sleep 2
hyprctl keyword monitor "HDMI-A-1,preferred,auto,1,mirror,eDP-1"
echo "{\"text\":\"󰍺 \",\"tooltip\":\"Mirroring monitors\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
