#!/bin/bash

function handle {
  case "$1" in 
    monitorremoved\>\>HDMI-A-1)
      hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1.25"
      hyprctl keyword monitor "HDMI-A-1,preferred,-1920x-216,2"
      echo "" > /tmp/custom_monitor_waybar
      pkill -RTMIN+3 waybar
      return
    ;;
    monitoradded\>\>HDMI-A-1)
      echo "{\"text\":\"󰍹 \",\"tooltip\":\"Monitor connected\"}" > /tmp/custom_monitor_waybar
      pkill -RTMIN+3 waybar
      return
    ;;
  esac
}
socat -t0 -,ignoreeof "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
