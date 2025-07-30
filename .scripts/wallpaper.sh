#!/usr/bin/bash

STATE_DIR="$HOME/.local/state/wallpaper"

mkdir -p "$STATE_DIR"

timestamps="$(cat /tmp/wlsunset.log | head -2 | tail -1)"
dawn_time="$(echo "$timestamps" | cut -d ',' -f 1)"
dawn_time="${dawn_time: -5:5}"
sunset_time="$(echo "$timestamps" | cut -d ',' -f 4)"
sunset_time="${sunset_time: -5:5}"

begin=$(date --date="$dawn_time" +%s)
end=$(date --date="$sunset_time" +%s)
now=$(date +%s)

if [[ "$begin" -le "$now" && "$now" -le "$end" ]]; then
    # day time
    mode="light"
else
    # night time
    mode="dark"
fi

queue_file="${STATE_DIR}/${mode}.queue"
wall_dir="$HOME/Pictures/walls-catppuccin-mocha/$mode"

next_wall="$(cat "$queue_file" | head -1)"

if [[ -z "$next_wall" ]]; then
    ls -1 "$wall_dir" | sort -R > "$queue_file"
    next_wall="$(cat "$queue_file" | head -1)"
fi

tail +2 "$queue_file" > "${queue_file}.tmp" && mv "${queue_file}.tmp" "$queue_file"

swww img "${wall_dir}/$next_wall" -t wipe --transition-angle 30
