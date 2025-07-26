#!/bin/bash

active_player="$(cat /tmp/active_player)"
for player in $(playerctl -l) ; do
    if [[ "$(playerctl -p "$player" status)" == "Playing" ]]; then
        playerctl -p "$player" "$1"
        echo "$player" > /tmp/active_player
        exit 0
    fi
done

for player in $(playerctl -l) ; do
    if [[ "$player" == "$active_player" ]]; then
        playerctl -p "$player" "$1"
        exit 0
    fi
done

player="$(playerctl -l | head -1)"
playerctl -p "$player" "$1"
echo "$player" > /tmp/active_player
