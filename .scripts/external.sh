#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
pkill -x wl-mirror
niri msg output "$monitor" on
sleep 2
niri msg output eDP-1 off
echo "{\"text\":\"󰶐 \",\"tooltip\":\"$monitor only\"}" > /tmp/custom_monitor_waybar
pkill -RTMIN+3 waybar
