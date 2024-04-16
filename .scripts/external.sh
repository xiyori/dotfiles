#!/bin/bash

hyprctl keyword monitor "HDMI-A-1,preferred,auto,2"
sleep 2
hyprctl keyword monitor "eDP-1,disable"
echo "{\"text\":\"󰶐 \",\"tooltip\":\"External monitor only\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
