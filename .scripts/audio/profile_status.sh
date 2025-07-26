#!/bin/bash

profile="$(cat /tmp/active_profile)"

if [[ -z "$profile" ]]; then
    exit 0
fi

icon="$(cat ~/.config/myeffects/icons.txt | grep -F "$profile" | cut -f 2)"

echo "{\"text\":\"$icon\",\"tooltip\":\"$profile\"}"
