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

active_sink="$(~/.scripts/audio/get_active_sink.sh)"
new_active_sink="$1"

# Disconnect profile from loudness 
~/.scripts/audio/remove_output_links.sh "${output_node}:Output L"
~/.scripts/audio/remove_output_links.sh "${output_node}:Output R"

# Disconnect profile from sink
~/.scripts/audio/remove_input_links.sh "${active_sink}:playback_FL"
~/.scripts/audio/remove_input_links.sh "${active_sink}:playback_FR"

# Disconnect sub profile and sink if any
sub_profile="$(cat ~/.config/myeffects/sub_profiles.txt | grep "^$active_sink")"
if [ -n "$sub_profile" ]; then
    sub_sink="$(echo "$sub_profile" | cut -f 2)"

    ~/.scripts/audio/remove_output_links.sh "${output_node}:Output L"
    ~/.scripts/audio/remove_output_links.sh "${output_node}:Output R"

    ~/.scripts/audio/remove_input_links.sh "${sub_sink}:playback_FL"
    ~/.scripts/audio/remove_input_links.sh "${sub_sink}:playback_FR"
fi

profile="$(cat ~/.config/myeffects/profiles.txt | grep "$new_active_sink" | cut -f 2)"
if [ -z "$profile" ]; then
    # No profile found, connect directly to sink
    pw-link "${output_node}:Output L" "${new_active_sink}:playback_FL"
    pw-link "${output_node}:Output R" "${new_active_sink}:playback_FR"
else
    # Connect new effects profile to sink
    pw-link "${profile}:Output L" "${new_active_sink}:playback_FL"
    pw-link "${profile}:Output R" "${new_active_sink}:playback_FR"

    # Connect loudness to profile
    pw-link "${output_node}:Output L" "${profile}:Input L"
    pw-link "${output_node}:Output R" "${profile}:Input R"

    # Connect sub profile and sink if any
    sub_profile="$(cat ~/.config/myeffects/sub_profiles.txt | grep "^$new_active_sink")"
    if [ -n "$sub_profile" ]; then
        sub_sink="$(echo "$sub_profile" | cut -f 2)"
        sub_profile="$(echo "$sub_profile" | cut -f 3)"

        pw-link "${sub_profile}:Output L" "${sub_sink}:playback_FL"
        pw-link "${sub_profile}:Output R" "${sub_sink}:playback_FR"

        pw-link "${output_node}:Output L" "${sub_profile}:Input L"
        pw-link "${output_node}:Output R" "${sub_profile}:Input R"

        pactl set-sink-volume "$sub_sink" 100%
    fi
fi

pactl set-sink-volume "$new_active_sink" 100%

pkill -RTMIN+1 waybar

notify-send --expire-time 3000 "Audio: $(~/.scripts/audio/active_sink_nick.sh)"
