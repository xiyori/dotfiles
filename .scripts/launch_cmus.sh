#!/bin/bash
if ! pgrep -f "alacritty -e cmus" > /dev/null 2>&1 ; then
    mkdir -p /tmp/cmus_status
    cp ~/.local/state/cmus_status/placeholder.png /tmp/cmus_status/cmus_status_cover.jpg
    alacritty -e cmus >/dev/null 2>&1 &
    sleep 0.5
    qimgv /tmp/cmus_status/cmus_status_cover.jpg >/dev/null 2>&1 &
fi
if [[ "$#" -eq 1 ]]; then
    cmus-remote -f "$1"
fi
