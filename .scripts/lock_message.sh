#!/bin/bash

tooltip="$(cat /tmp/player_metadata)"

if [[ -z "$tooltip" ]]; then
    tooltip="$(hyprctl splash)"
fi

case $(~/.scripts/audio/player.sh status 2> /dev/null) in 
  Playing)
    icon="󰐊"
  ;;
  Paused)
    icon="󰏤"
  ;;
esac

echo "$icon $tooltip"
