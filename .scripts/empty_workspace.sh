#!/bin/bash
# Focus the trailing empty workspace of the focused output, or move the focused window there.

workspaces="$(niri msg --json workspaces)"
output="$(jq -r '.[] | select(.is_focused) | .output' <<< "$workspaces")"
idx="$(jq -r --arg o "$output" '[.[] | select(.output == $o) | .idx] | max' <<< "$workspaces")"

if [[ "$1" == "move" ]]; then
    niri msg action move-window-to-workspace "$idx"
else
    niri msg action focus-workspace "$idx"
fi
