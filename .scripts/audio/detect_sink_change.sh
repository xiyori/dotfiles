#!/bin/bash

if [ -n "$(~/.scripts/audio/get_active_sink.sh)" ]; then
    exit 0
fi

for priority_sink in $(cat ~/.config/myeffects/profiles.txt | cut -f 1) ; do
    for sink in $(~/.scripts/audio/list_sinks.sh) ; do
        if [ "$sink" == "$priority_sink" ]; then
            ~/.scripts/audio/set_active_sink.sh "$sink"
            exit 0
        fi
    done
done
~/.scripts/audio/next_active_sink.sh
