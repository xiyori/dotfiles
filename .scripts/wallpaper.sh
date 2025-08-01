#!/usr/bin/bash

STATE_DIR="$HOME/.local/state/wallpaper"

mkdir -p "$STATE_DIR"

# timestamps="$(head -2 /tmp/wlsunset.log | tail -1)"
# dawn_time="$(echo "$timestamps" | cut -d ',' -f 1)"
# dawn_time="${dawn_time: -5:5}"
# sunset_time="$(echo "$timestamps" | cut -d ',' -f 4)"
# sunset_time="${sunset_time: -5:5}"
#
# begin=$(date --date="$dawn_time" +%s)
# end=$(date --date="$sunset_time" +%s)
# now=$(date +%s)

# if [[ "$begin" -le "$now" && "$now" -le "$end" ]]; then
if [[ "$(sunwait poll "${LATITUDE}N" "${LONGITUDE}E")" == "DAY" ]]; then
    # day time
    mode="light"
else
    # night time
    mode="dark"
fi

if [[ -z "$1" && "$(cat /tmp/wall_mode)" == "$mode" ]]; then
    exit 0
fi

echo "$mode" > /tmp/wall_mode
queue_file="${STATE_DIR}/${mode}.queue"
wall_dir="$HOME/Pictures/walls-catppuccin-mocha/$mode"

next_wall="$(head -1 "$queue_file")"

if [[ -z "$next_wall" ]]; then
    ls -1 "$wall_dir" | sort -R > "$queue_file"
    next_wall="$(head -1 "$queue_file")"
fi

tail +2 "$queue_file" > "${queue_file}.tmp" && mv "${queue_file}.tmp" "$queue_file"

if [[ -z "$1" ]]; then
    trans="-t wipe --transition-angle 30"
else
    trans="-t none"
fi
swww img "${wall_dir}/$next_wall" $trans
