#!/bin/bash

metadata="$(~/.scripts/audio/player.sh metadata 2> /dev/null)"
artist="$(echo "$metadata" | grep xesam:artist)"
artist="$(echo ${artist#*artist})"
title="$(echo "$metadata" | grep xesam:title)"
title="$(echo ${title#*title})"

if [[ -z "$title" ]]; then
    echo > /tmp/player_metadata
elif [[ -z "$artist" ]]; then
    echo "$title" | jq -R . > /tmp/player_metadata
else
    echo "$artist - $title" | jq -R . > /tmp/player_metadata
fi
