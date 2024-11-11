#!/bin/bash
# Script by @miyl https://gist.github.com/miyl

# Removing pulseaudio means removing pacmd, so this is an attempt at switching the default via pactl instead.

# This script switches between whatever sinks exist.
# sinks can be specified by name or index. Index changes sometimes when you disconnect and reconnect, restart or whatever, so names are better as they are persistent.
# Annoyingly the command used to switch audio over to a new sink cannot take a name as its argument, otherwise I'd only need the name here.

# TODO: Trigger a zenity or dmenu dialog with entr that asks whether to switch monitor and/or sound to hdmi? Could do
# the same for mounting.

active_sinks="$(~/.scripts/audio/list_active_sinks.sh)"
for sink in $(~/.scripts/audio/list_sinks.sh) ; do
    [ -z "$first" ] && first="$sink" # Save the first index in case the current default is the last in the list
    # Subsequent pass, don't need continue above
    if [ -n "$next" ]; then
        new_active_sink="$sink"
        break
    fi
    for active_sink in $active_sinks ; do
        if [ "$sink" == "$active_sink" ]; then
            next=1
            break
        fi
    done
done

# Don't particularly like this method of making it circular, but...
[ -z "$new_active_sink" ] && new_active_sink="$first"

~/.scripts/audio/set_active_sink.sh "$new_active_sink"
