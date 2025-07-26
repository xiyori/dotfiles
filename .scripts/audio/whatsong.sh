#!/bin/bash

artist=$(~/.scripts/audio/player.sh metadata 2> /dev/null | grep xesam:artist)
artist="$(echo ${artist#*artist})"
echo "$artist" > /tmp/current_artist
title="$(~/.scripts/audio/player.sh metadata 2> /dev/null | grep xesam:title)"
title="$(echo ${title#*title})"
echo "$title" > /tmp/current_title

if [[ -z "$artist" ]]; then
    echo "$title" > /tmp/current_tooltip
else
    echo "$artist - $title" > /tmp/current_tooltip
fi
