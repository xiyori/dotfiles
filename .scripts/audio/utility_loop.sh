#!/bin/bash

while : ; do
    ~/.scripts/audio/detect_sink_change.sh
    ~/.scripts/audio/whatsong.sh
    ~/.scripts/audio/tooltip.sh
    [ -z "$1" ] && ~/.scripts/audio/youtube_volume.sh
    sleep 1
done
