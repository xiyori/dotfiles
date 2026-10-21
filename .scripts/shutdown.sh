#!/usr/bin/bash

hyprctl clients -j | jq -r '.[].address' | xargs -I {} hyprctl dispatch hl.dsp.window.close\({window = \"address:{}\"}\)
systemctl "$1"
