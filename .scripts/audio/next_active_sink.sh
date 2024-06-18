#!/bin/bash
# Script by @miyl https://gist.github.com/miyl

# Removing pulseaudio means removing pacmd, so this is an attempt at switching the default via pactl instead.

# This script switches between whatever sinks exist.
# sinks can be specified by name or index. Index changes sometimes when you disconnect and reconnect, restart or whatever, so names are better as they are persistent.
# Annoyingly the command used to switch audio over to a new sink cannot take a name as its argument, otherwise I'd only need the name here.

# TODO: Trigger a zenity or dmenu dialog with entr that asks whether to switch monitor and/or sound to hdmi? Could do
# the same for mounting.

output_node="LSP Loudness Compensator Stereo"

if ! pactl list clients | grep "$output_node" > /dev/null 2>&1; then
    notify-send --expire-time 3000 "Error: Carla not started"
    exit 0
fi

active_sink="$(~/.scripts/audio/get_active_sink.sh)"
for sink in $(~/.scripts/audio/list_sinks.sh) ; do
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

~/.scripts/audio/set_active_sink.sh $new_active_sink
