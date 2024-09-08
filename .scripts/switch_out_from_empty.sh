#!/bin/bash
# Original script by OptimusCrime73 from https://www.reddit.com/r/hyprland/comments/1722we7/automatically_switch_from_empty_workspace/
function handle {
    if [[ ${1:0:11} == "closewindow" ]] && hyprctl activeworkspace | grep "windows: 0" > /dev/null ; then
        active_id="$(hyprctl activeworkspace | grep "workspace ID" | awk '{ print $3 }')"
        regex=".* on monitor (.*)\:"
        if [[ "$(hyprctl activeworkspace | grep "on monitor")" =~ $regex ]]; then
            active_monitor="${BASH_REMATCH[1]}"
        else
            echo "Unknown error, cannot find active monitor"
            return 1
        fi
        if (( active_id > 0 )); then
            return 0
        fi
        prev_id=""
        next_id=""
        find_next=""
        for id in $(hyprctl workspaces | grep -e "workspace ID" -e "$active_monitor" | awk '{ print $3 }' | sort -g) ; do
            if (( id > 0 )); then
                if (( active_id < 0 )); then
                    prev_id="$id"
                    break
                fi
                if [ -n "$find_next" ]; then
                    next_id="$id"
                    break
                fi
                if [ "$id" == "$active_id" ]; then
                    find_next=1
                    continue
                fi
                prev_id="$id"
            fi
        done
        if [ -z "$prev_id" ]; then
            if [ -z "$next_id" ]; then
                prev_id=1
            else
                prev_id="$next_id"
            fi
        fi
        hyprctl dispatch workspace "$prev_id"
        echo "Switched from $active_id to $prev_id"
    fi
}

socat STDOUT "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
