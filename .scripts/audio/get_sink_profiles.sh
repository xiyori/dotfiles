#!/bin/bash

sink="$1"
while read -r profile; do
    priority_sink="$(echo "$profile" | cut -f 1)"
    if echo "$sink" | grep -q "^$priority_sink" ; then
        echo "$profile"
    fi
done < <(cat ~/.config/myeffects/profiles.txt)
