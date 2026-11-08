#!/bin/bash
# Float and center LibreWolf extension popups.

niri msg --json event-stream \
    | jq --unbuffered -r 'select(.WindowOpenedOrChanged) | .WindowOpenedOrChanged.window
        | select(.app_id == "librewolf" and (.title // "" | startswith("Extension:")) and (.is_floating | not)) | .id' \
    | while read -r id; do
        niri msg action move-window-to-floating --id "$id"
        niri msg action set-window-width --id "$id" 600
        niri msg action set-window-height --id "$id" 800
        niri msg action center-window --id "$id"
        niri msg action focus-window --id "$id"
    done
