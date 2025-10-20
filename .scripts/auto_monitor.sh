#!/bin/bash

function handle {
  case "$1" in 
    monitorremoved\>\>*)
      echo $1
      monitor="${1#*>>}"
      if [[ "$monitor" = "eDP-1" ]]; then
          return
      fi
      hyprctl keyword monitor "eDP-1,preferred,0x0,1.8"
      echo "" > /tmp/custom_monitor_waybar
      pkill -RTMIN+3 waybar
      return
    ;;
    monitoradded\>\>*)
      echo $1
      monitor="${1#*>>}"
      if [[ "$monitor" = "eDP-1" ]]; then
          return
      fi
      echo "$monitor" > /tmp/custom_monitor_waybar_monitor
      echo "{\"text\":\"󰍹 \",\"tooltip\":\"$monitor connected\"}" > /tmp/custom_monitor_waybar
      pkill -RTMIN+3 waybar
      return
    ;;
  esac
}
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
