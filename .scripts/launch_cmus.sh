#!/bin/bash
if ! pgrep -f "alacritty --class cmus,cmus" > /dev/null 2>&1 ; then
    mkdir -p /tmp/cmus_status
    cp ~/.local/state/cmus_status/placeholder.png /tmp/cmus_status/cmus_status_cover.jpg
    alacritty --class "cmus,cmus" -e cmus >/dev/null 2>&1 &
    sleep 0.2
    alacritty --class "cmus-cava,cmus-cava" -o "font.size=8" -e cava >/dev/null 2>&1 &
    sleep 0.2
    hyprctl dispatch splitratio 0.195
    qimgv /tmp/cmus_status/cmus_status_cover.jpg >/dev/null 2>&1 &
    sleep 0.2
    hyprctl dispatch splitratio -0.5
    hyprctl dispatch focuswindow 'class:^(cmus)$'
fi
if [[ "$#" -eq 1 ]]; then
    cmus-remote -f "$1"
fi
