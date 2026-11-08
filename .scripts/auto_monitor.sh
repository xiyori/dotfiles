#!/bin/bash

# niri has no output hotplug events, so poll the output list
function list_outputs {
  niri msg --json outputs | jq -r 'keys[]'
}

function removed {
  echo "removed $1"
  if [[ "$1" = "eDP-1" ]]; then
      return
  fi
  pkill -x wl-mirror
  niri msg output eDP-1 on
  echo "" > /tmp/custom_monitor_waybar
  ~/.scripts/bar_refresh monitor
}

function added {
  echo "added $1"
  if [[ "$1" = "eDP-1" ]]; then
      return
  fi
  echo "$1" > /tmp/custom_monitor_waybar_monitor
  echo "{\"text\":\"󰍹 \",\"tooltip\":\"$1 connected\"}" > /tmp/custom_monitor_waybar
  ~/.scripts/bar_refresh monitor
}

prev="$(list_outputs)"
while sleep 2; do
  cur="$(list_outputs)" || continue
  [[ "$cur" == "$prev" ]] && continue
  for monitor in $(comm -23 <(echo "$prev") <(echo "$cur")); do removed "$monitor"; done
  for monitor in $(comm -13 <(echo "$prev") <(echo "$cur")); do added "$monitor"; done
  prev="$cur"
done
