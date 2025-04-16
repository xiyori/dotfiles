#!/bin/bash

artist=$(playerctl metadata 2> /dev/null | grep xesam:artist)
artist="$(echo ${artist#*artist})"
title="$(playerctl metadata 2> /dev/null | grep xesam:title)"
title="$(echo ${title#*title})"

if [ -z "$artist" ]; then
    tooltip="$title"
else
    tooltip="$artist - $title"
fi

if [ -z "$tooltip" ]; then
    tooltip="$(hyprctl splash)"
fi
echo "$tooltip"
