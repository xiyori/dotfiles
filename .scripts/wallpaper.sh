#!/usr/bin/bash

STATE_DIR="${HOME}/.local/state/wallpaper"
WALLS_DIR="${HOME}/Pictures/walls-catppuccin-mocha"

mkdir -p "$STATE_DIR"

mode="$(cat /tmp/wall_mode)"

if [[ "$1" == "query" ]]; then
    queue_file="${STATE_DIR}/${mode}.queue"
    wall_dir="${WALLS_DIR}/$mode"
    wall="$(head -1 "$queue_file")"
    echo "${wall_dir}/$wall"
    exit
fi

# if [[ "$begin" -le "$now" && "$now" -le "$end" ]]; then
if [[ "$(sunwait poll "${LATITUDE}N" "${LONGITUDE}E")" == "DAY" ]]; then
    # day time
    new_mode="light"
else
    # night time
    new_mode="dark"
fi

if [[ -z "$1" && "$new_mode" == "$mode" ]]; then
    exit 0
fi

echo "$new_mode" > /tmp/wall_mode
queue_file="${STATE_DIR}/${new_mode}.queue"
wall_dir="${WALLS_DIR}/$new_mode"

tail +2 "$queue_file" > "${queue_file}.tmp" && mv "${queue_file}.tmp" "$queue_file"
new_wall="$(head -1 "$queue_file")"

if [[ -z "$new_wall" ]]; then
    ls -1 "$wall_dir" | sort -R > "$queue_file"
    new_wall="$(head -1 "$queue_file")"
fi

if [[ -z "$1" || "$1" == "next" ]]; then
    trans="-t wipe --transition-angle 30"
else
    trans="-t none"
fi
swww img "${wall_dir}/$new_wall" $trans
