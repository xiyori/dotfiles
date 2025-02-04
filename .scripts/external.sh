#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
hyprctl keyword monitor "$monitor,preferred,auto,1"
sleep 2
hyprctl keyword monitor "eDP-1,disable"
echo "{\"text\":\"󰶐 \",\"tooltip\":\"$monitor only\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
