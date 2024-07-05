#!/bin/bash

pw-link -l | grep "|<- LSP Loudness Compensator Stereo:Output" > /dev/null && exit 0

for priority_sink in $(cat ~/.config/myeffects/profiles.txt | cut -f 1) ; do
    for sink in $(~/.scripts/audio/list_sinks.sh) ; do
        if [ "$sink" == "$priority_sink" ]; then
            ~/.scripts/audio/set_active_sink.sh "$sink"
            exit 0
        fi
    done
done
~/.scripts/audio/next_active_sink.sh
