#!/bin/bash

STATE_DIR="$HOME/.local/state/cmus_status"
COVER_DIR="${STATE_DIR}/cover"
COVER_PATH="$COVER_DIR/cmus_status_cover.jpg"

status=$2
file_path=$(echo "$@" | grep -o "file .* artist")
file_path="${file_path:5:-7}"
if [[ "$file_path" == cue://* ]]; then
    file_path="$(dirname "${file_path:6}")"
elif [ -z "$file_path" ]; then
    file_path=$(echo "$@" | grep -o "file .*")
    file_path="${file_path:5}"
fi

if [ -z "$file_path" ]; then
    file_dir=""
else
    file_dir="$(dirname "${file_path}")"
fi

if [ "$(cat "${STATE_DIR}/current_file")" == "$file_dir" ]; then
    exit 0
fi

echo "$file_dir" > "${STATE_DIR}/current_file"

if [ -n "$file_dir" ]; then
    img_name="$(ls -S1 "$file_dir" | grep -oiE ".*(cover|folder|artwork|albumart|jacket|front).*\.(jpg|jpeg|png|tiff)" | head -1)"
    if [ -z "$img_name" ]; then
        img_name="$(ls -S1 "$file_dir" | grep -oiE ".*\.(jpg|jpeg|png|tiff)" | head -1)"
    fi
    if ! cp "${file_dir}/${img_name}" "$COVER_PATH" ; then
        ffmpeg -i "$file_path" -an -c:v copy "${STATE_DIR}/cover.jpg"
        if cp "${STATE_DIR}/cover.jpg" "$COVER_PATH" ; then
            rm "${STATE_DIR}/cover.jpg"
        else
            cp "${STATE_DIR}/placeholder.png" "$COVER_PATH"
        fi
    fi
else
    cp "${STATE_DIR}/placeholder.png" "$COVER_PATH"
fi
