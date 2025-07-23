#!/bin/bash

while : ; do
    ~/.scripts/audio/whatsong.sh
    ~/.scripts/audio/tooltip.sh
    if [ -z "$1" ]; then
        ~/.scripts/audio/youtube_volume.sh
        ~/.scripts/audio/detect_sink_change.sh
    fi
    sleep 1
done
