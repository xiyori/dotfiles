#!/bin/bash

if [[ -n "$(~/.scripts/audio/list_active_sinks.sh)" ]]; then
    exit 0
fi

while read -r profile; do
    priority_sink="$(echo "$profile" | cut -f 1)"
    for sink in $(~/.scripts/audio/list_sinks.sh) ; do
        if echo "$sink" | grep -q "^$priority_sink" ; then
            ~/.scripts/audio/set_active_sink.sh "$sink" "$profile"
            exit 0
        fi
    done
done < <(cat ~/.config/myeffects/profiles.txt)
~/.scripts/audio/next_active_sink.sh
