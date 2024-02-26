#!/bin/bash
if ! pgrep -f "alacritty -e cmus" &> /dev/null 2>&1 ; then
    nohup alacritty -e cmus >/dev/null 2>&1 &
    nohup ristretto ~/.local/state/cmus_status/cover >/dev/null 2>&1 &
    sleep 0.5
fi
if [ "$#" -eq 1 ]; then
    cmus-remote -f "$1"
fi
