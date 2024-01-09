#!/bin/bash
# Original script by OptimusCrime73 from https://www.reddit.com/r/hyprland/comments/1722we7/automatically_switch_from_empty_workspace/
function handle {
    if [[ ${1:0:11} == "closewindow" ]]; then
        echo "Close Window detected"
        if hyprctl workspaces | grep "windows: 0"; then
            echo "Empty workspace detected"
            hyprctl dispatch workspace e-1
            # sleep 0.0001
            # hyprctl dispatch workspace 1
        fi
    fi
}
socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
