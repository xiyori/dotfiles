#!/bin/bash

tooltip="$(cat /tmp/player_metadata)"

case $(~/.scripts/audio/player.sh status 2> /dev/null) in 
  Playing)
    icon="󰐊 "
  ;;
  Paused)
    icon="󰏤 "
  ;;
esac

if [[ -z "$tooltip" || -z "$icon" ]]; then
    tooltip="$(hyprctl splash)"
fi

echo "${icon}${tooltip}"
