#!/bin/bash

if hyprctl activewindow | grep "class: cmus" ; then
    for pid in $(hyprctl clients | awk '/workspace:|pid: / {print $0};' | grep --after-context 1 "(Music)" | grep pid | cut -d ":" -f 2) ; do
        kill $pid
    done
else
    hyprctl dispatch killactive
fi
