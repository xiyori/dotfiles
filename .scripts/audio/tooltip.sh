#!/bin/bash

convert_to_json() {
    read tmp
    tmp="$(echo "$tmp" | jq -R .)"
    echo "${tmp:1:-1}"
}

sink="$(~/.scripts/audio/list_active_sinks.sh | head -1)"
nick="$(~/.scripts/audio/active_sink_nick.sh)"

case "$(pactl get-sink-mute "$sink")" in
  *yes)
    echo 1 > /tmp/muted
  ;;
  *)
    echo 0 > /tmp/muted
  ;;
esac

tooltip="$(cat /tmp/current_tooltip | convert_to_json)"

if [ -z "$tooltip" ]; then
    tooltip="$nick"
fi

echo "$tooltip" > /tmp/waybar_tooltip
