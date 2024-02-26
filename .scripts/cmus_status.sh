#!/bin/bash

STATE_DIR="$HOME/.local/state/cmus_status"
COVERS_DIR="$STATE_DIR/cover"

status=$2
file_path=$(echo "$@" | grep -o "file .* artist")
file_path="${file_path#file }"
file_path="${file_path% artist}"

if [ "$file_path" != "" ]; then
    file_dir="$(dirname "${file_path}")"
    img_name="$(ls -S1 "${file_dir}" | grep -oiE ".*(cover|folder|artwork|albumart).*\.(jpg|jpeg|png|tiff)" | head -1)"
    if ! cp "${file_dir}/${img_name}" "$COVERS_DIR/cover.jpg" ; then
        ffmpeg -i "${file_path}" -vframes 1 -update true -an "$STATE_DIR/cover.jpg"
        if [ -f "$STATE_DIR/cover.jpg" ]; then
            mv "$STATE_DIR/cover.jpg" "$COVERS_DIR/cover.jpg"
        else
            cp "$STATE_DIR/placeholder.png" "$COVERS_DIR/cover.jpg"
        fi
    fi
else
    cp "$STATE_DIR/placeholder.png" "$COVERS_DIR/cover.jpg"
fi
