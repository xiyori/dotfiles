#!/bin/bash

artist=$(~/.scripts/audio/player.sh metadata 2> /dev/null | grep xesam:artist)
artist="$(echo ${artist#*artist})"
title="$(~/.scripts/audio/player.sh metadata 2> /dev/null | grep xesam:title)"
title="$(echo ${title#*title})"

if [[ -z "$artist" ]]; then
    metadata="$title"
else
    metadata="$artist - $title"
fi
echo "$metadata" | jq -R . > /tmp/player_metadata
