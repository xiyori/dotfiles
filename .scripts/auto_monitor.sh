#!/bin/bash

function handle {
  case "$1" in 
    monitorremoved\>\>*)
      monitor="${1#*>>}"
      if [ "$monitor" = "eDP-1" ]; then
          return
      fi
      hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
      hyprctl keyword monitor "DP-1,preferred,-1920x-216,2"
      hyprctl keyword monitor "HDMI-A-2,preferred,-1920x-216,1"
      echo "" > /tmp/custom_monitor_waybar
      pkill -RTMIN+3 waybar
      return
    ;;
    monitoradded\>\>*)
      monitor="${1#*>>}"
      if [ "$monitor" = "eDP-1" ]; then
          return
      fi
      echo "$monitor" > /tmp/custom_monitor_waybar_monitor
      echo "{\"text\":\"󰍹 \",\"tooltip\":\"$monitor connected\"}" > /tmp/custom_monitor_waybar
      pkill -RTMIN+3 waybar
      return
    ;;
  esac
}
socat STDOUT "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
