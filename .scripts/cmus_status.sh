#!/bin/bash

STATE_DIR="$HOME/.local/state/cmus_status"
COVER_DIR="$STATE_DIR/cover"
COVER_PATH="$COVER_DIR/cmus_status_cover.jpg"

status=$2
file_path=$(echo "$@" | grep -o "file .* artist")
file_path="${file_path:5:-7}"
if [[ "$file_path" == cue://* ]]; then
    file_path="$(dirname "${file_path:6}")"
fi

if [ "$file_path" != "" ]; then
    file_dir="$(dirname "${file_path}")"
    img_name="$(ls -S1 "${file_dir}" | grep -oiE ".*(cover|folder|artwork|albumart|jacket).*\.(jpg|jpeg|png|tiff)" | head -1)"
    if ! cp "${file_dir}/${img_name}" "$COVER_PATH" ; then
        ffmpeg -i "${file_path}" -vframes 1 -update true -an "$STATE_DIR/cover.jpg"
        if [ -f "$STATE_DIR/cover.jpg" ]; then
            mv "$STATE_DIR/cover.jpg" "$COVER_PATH"
        else
            cp "$STATE_DIR/placeholder.png" "$COVER_PATH"
        fi
    fi
else
    cp "$STATE_DIR/placeholder.png" "$COVER_PATH"
fi
