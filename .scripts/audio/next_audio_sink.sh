#!/bin/bash
# Script by @miyl https://gist.github.com/miyl

# Removing pulseaudio means removing pacmd, so this is an attempt at switching the default via pactl instead.

# This script switches between whatever sinks exist.
# sinks can be specified by name or index. Index changes sometimes when you disconnect and reconnect, restart or whatever, so names are better as they are persistent.
# Annoyingly the command used to switch audio over to a new sink cannot take a name as its argument, otherwise I'd only need the name here.

# TODO: Trigger a zenity or dmenu dialog with entr that asks whether to switch monitor and/or sound to hdmi? Could do
# the same for mounting.

output_node="LSP Loudness Compensator Stereo"

get_all_sinks() {
  pactl list short sinks | grep -v myeffects_sink | cut -f 2
}

get_sink_profile() {
    profile="$(cat ~/.config/myeffects_profiles.txt | grep "$1" | cut -f 2)"
    if [ -z "$profile" ]; then
        echo "$output_node"
    else
        echo "$profile"
    fi
}

if ! pactl list clients | grep "$output_node" > /dev/null 2>&1; then
    notify-send --expire-time 3000 "Error: Carla not started"
    exit 0
fi

active_sink="$(~/.scripts/audio/get_active_sink.sh)"
for sink in $(get_all_sinks) ; do
  [ -z "$first" ] && first="$sink" # Save the first index in case the current default is the last in the list
  if [ "$sink" == "$active_sink" ]; then
    next=1;
  # Subsequent pass, don't need continue above
  elif [ -n "$next" ]; then
    new_active_sink="$sink"
    break
  fi
done

# Don't particularly like this method of making it circular, but...
[ -z "$new_active_sink" ] && new_active_sink="$first"

# Set default sink for new audio playback
pw-link -d "${output_node}:Output L" "${active_sink}:playback_FL"
pw-link -d "${output_node}:Output R" "${active_sink}:playback_FR"

pw-link "${output_node}:Output L" "${new_active_sink}:playback_FL"
pw-link "${output_node}:Output R" "${new_active_sink}:playback_FR"

old_profile="$(get_sink_profile "$active_sink")"
profile="$(get_sink_profile "$new_active_sink")"
if [ "$profile" != "$old_profile" ]; then
    pw-link -d "myeffects_sink:monitor_FL" "${old_profile}:Input L"
    pw-link -d "myeffects_sink:monitor_FR" "${old_profile}:Input R"

    pw-link "myeffects_sink:monitor_FL" "${profile}:Input L"
    pw-link "myeffects_sink:monitor_FR" "${profile}:Input R"
fi

pactl set-sink-volume "$new_active_sink" 100%

pkill -RTMIN+1 waybar

notify-send --expire-time 3000 "Audio: $(~/.scripts/audio/active_sink_nick.sh)"
