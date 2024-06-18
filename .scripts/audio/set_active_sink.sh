#!/bin/bash

output_node="LSP Loudness Compensator Stereo"

get_sink_profile() {
    profile="$(cat ~/.config/myeffects/profiles.txt | grep "$1" | cut -f 2)"
    if [ -z "$profile" ]; then
        echo "$output_node"
    else
        echo "$profile"
    fi
}

remove_old_profile() {
    for link in "$(pw-link -Iol "$1" | tail -n +2 | awk '{ print $1 }')" ; do
        pw-link -d "$link"
    done
}

active_sink="$(~/.scripts/audio/get_active_sink.sh)"
new_active_sink="$1"

# Disconnect the pipeline to avoid volume spikes
remove_old_profile "myeffects_sink:monitor_FL"
remove_old_profile "myeffects_sink:monitor_FR"

# Set default sink for new audio playback
pw-link -d "${output_node}:Output L" "${active_sink}:playback_FL"
pw-link -d "${output_node}:Output R" "${active_sink}:playback_FR"

pw-link "${output_node}:Output L" "${new_active_sink}:playback_FL"
pw-link "${output_node}:Output R" "${new_active_sink}:playback_FR"

# Apply new effects profile
profile="$(get_sink_profile "$new_active_sink")"
pw-link "myeffects_sink:monitor_FL" "${profile}:Input L"
pw-link "myeffects_sink:monitor_FR" "${profile}:Input R"

pactl set-sink-volume "$new_active_sink" 100%

pkill -RTMIN+1 waybar

notify-send --expire-time 3000 "Audio: $(~/.scripts/audio/active_sink_nick.sh)"
