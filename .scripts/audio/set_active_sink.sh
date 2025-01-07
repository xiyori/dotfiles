#!/bin/bash

# SPDX-License-Identifier: MIT

## Copyright (C) 2009 Przemyslaw Pawelczyk <przemoc@gmail.com>
##
## This script is licensed under the terms of the MIT license.
## https://opensource.org/licenses/MIT
#
# Lockable script boilerplate

### HEADER ###

LOCKFILE="/tmp/`basename $0`.lock"
LOCKFD=99

# PRIVATE
_lock()             { flock -$1 $LOCKFD; }
_no_more_locking()  { _lock u; _lock xn && rm -f $LOCKFILE; }
_prepare_locking()  { eval "exec $LOCKFD>\"$LOCKFILE\""; trap _no_more_locking EXIT; }

# ON START
_prepare_locking

# PUBLIC
exlock_now()        { _lock xn; }  # obtain an exclusive lock immediately or fail
exlock()            { _lock x; }   # obtain an exclusive lock
shlock()            { _lock s; }   # obtain a shared lock
unlock()            { _lock u; }   # drop a lock

### BEGIN OF SCRIPT ###

# Simplest example is avoiding running multiple instances of script.
exlock_now || exit 1

output_node="LSP Loudness Compensator Stereo"

if ! pactl list clients | grep "LSP Loudness Compensator Stereo" > /dev/null 2>&1; then
    notify-send --expire-time 3000 "Error: Carla not started"
    exit 0
fi

active_sinks="$(~/.scripts/audio/list_active_sinks.sh)"
new_active_sink="$1"

# Disconnect profile from loudness 
~/.scripts/audio/remove_output_links.sh "${output_node}:Output L"
~/.scripts/audio/remove_output_links.sh "${output_node}:Output R"

# Disconnect profile from sink(s)
for active_sink in $active_sinks ; do
    ~/.scripts/audio/remove_input_links.sh "${active_sink}:playback_FL"
    ~/.scripts/audio/remove_input_links.sh "${active_sink}:playback_FR"
done

profiles="$(cat ~/.config/myeffects/profiles.txt | grep "$new_active_sink")"
if [ -z "$profiles" ]; then
    # No profile found, connect directly to sink
    pw-link "${output_node}:Output L" "${new_active_sink}:playback_FL"
    pw-link "${output_node}:Output R" "${new_active_sink}:playback_FR"
else
    in_profile="$(echo "$profiles" | cut -f 2)"
    out_profile="$(echo "$profiles" | cut -f 3)"
    if [ -z "$out_profile" ]; then
        out_profile="$in_profile"
    fi
    # Connect new effects profile to sink
    pw-link "${out_profile}:Output L" "${new_active_sink}:playback_FL"
    pw-link "${out_profile}:Output R" "${new_active_sink}:playback_FR"

    # Connect loudness to profile
    pw-link "${output_node}:Output L" "${in_profile}:Input L"
    pw-link "${output_node}:Output R" "${in_profile}:Input R"

    # Connect sub profile and sink if any
    sub_profiles="$(cat ~/.config/myeffects/sub_profiles.txt | grep "^$new_active_sink")"
    if [ -n "$sub_profiles" ]; then
        sub_sink="$(echo "$sub_profiles" | cut -f 2)"
        in_sub_profile="$(echo "$sub_profiles" | cut -f 3)"
        out_sub_profile="$(echo "$sub_profiles" | cut -f 3)"
        if [ -z "$out_sub_profile" ]; then
            out_sub_profile="$in_sub_profile"
        fi

        pw-link "${out_sub_profile}:Output L" "${sub_sink}:playback_FL"
        pw-link "${out_sub_profile}:Output R" "${sub_sink}:playback_FR"

        pw-link "${output_node}:Output L" "${in_sub_profile}:Input L"
        pw-link "${output_node}:Output R" "${in_sub_profile}:Input R"

        pactl set-sink-volume "$sub_sink" 100%
    fi
fi

# Set bluetooth volume to -20db
if grep bluez <<< "$new_active_sink" ; then
    pactl set-sink-volume $new_active_sink 30419
else
    pactl set-sink-volume "$new_active_sink" 100%
fi

pkill -RTMIN+1 waybar

notify-send --expire-time 3000 "Audio: $(~/.scripts/audio/active_sink_nick.sh)"

unlock
