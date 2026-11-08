#!/bin/bash

monitor="$(cat /tmp/custom_monitor_waybar_monitor)"
if [[ -z "$monitor" ]]; then
  monitor="HDMI-A-1"
fi
niri msg output eDP-1 on
niri msg output "$monitor" on
sleep 2
pkill -x wl-mirror
wl-mirror -F --fullscreen-output "$monitor" eDP-1 > /dev/null 2>&1 & disown
echo "{\"text\":\"󰍺 \",\"tooltip\":\"Mirroring to $monitor\"}" > /tmp/custom_monitor_waybar
~/.scripts/bar_refresh monitor
