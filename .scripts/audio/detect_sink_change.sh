#!/bin/bash

if [ -n "$(~/.scripts/audio/list_active_sinks.sh)" ]; then
    exit 0
fi

for priority_sink in $(cat ~/.config/myeffects/profiles.txt | cut -f 1) ; do
    for sink in $(~/.scripts/audio/list_sinks.sh) ; do
        if [ "$sink" == "$priority_sink" ]; then
            profile="$(cat ~/.config/myeffects/profiles.txt | grep -m 1 "^$sink")"
            ~/.scripts/audio/set_active_sink.sh "$sink" "$profile"
            exit 0
        fi
    done
done
~/.scripts/audio/next_active_sink.sh
