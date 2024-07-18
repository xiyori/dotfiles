#!/bin/bash
if ! pgrep -f "alacritty -e cmus" > /dev/null 2>&1 ; then
    nohup alacritty -e cmus >/dev/null 2>&1 &
    sleep 0.5
    nohup qimgv ~/.local/state/cmus_status/cover/cmus_status_cover.jpg >/dev/null 2>&1 &
fi
if [ "$#" -eq 1 ]; then
    cmus-remote -f "$1"
fi
