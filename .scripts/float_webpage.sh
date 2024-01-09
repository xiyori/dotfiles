#!/bin/bash
# Original script by fabernostrum from https://www.reddit.com/r/hyprland/comments/157h2j9/float_a_specific_webpage/
target="$1"
function handle {
    case $1 in
    *"$target"*)
    # check if the window is floating
        floating=$(hyprctl clients | grep "$target" -A 10 | grep floating | awk '{print $2}')
        if [[ $floating -eq 0 ]]; then 
            hyprctl dispatch togglefloating title:"$target*"
        fi
    ;;
  esac
}
socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
