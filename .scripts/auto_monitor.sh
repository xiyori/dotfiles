#!/bin/bash

function handle {
  case "$1" in 
    monitorremoved\>\>HDMI-A-1)
      hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
      return
    ;;
    monitoradded\>\>HDMI-A-1)
      hyprctl keyword monitor "eDP-1,disable"
      return
    ;;
  esac
}
socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
