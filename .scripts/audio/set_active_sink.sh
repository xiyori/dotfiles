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

ll_status="$(cat /tmp/low_latency)"
output_node="$([ "$ll_status" == "low_latency" ] && echo "gain_sink:monitor_F" || echo "LSP Loudness Compensator Stereo:Output ")"

if ! pactl list clients | grep "LSP Loudness Compensator Stereo" > /dev/null 2>&1 ; then
    exit 0
fi
# if [ "$(ps -o etimes= -p "$(pgrep carla)")" -lt 7 ]; then
#     exit 0
# fi

active_sinks="$(~/.scripts/audio/list_active_sinks.sh)"
new_active_sink="$1"
profile="$2"

# Disconnect profile(s) from loudness
~/.scripts/audio/remove_output_links.sh "${output_node}L"
~/.scripts/audio/remove_output_links.sh "${output_node}R"

# Disconnect profile from sink(s)
for active_sink in $active_sinks ; do
    ~/.scripts/audio/remove_input_links.sh "${active_sink}:playback_FL"
    ~/.scripts/audio/remove_input_links.sh "${active_sink}:playback_FR"
done

volume="$(echo "$profile" | cut -f 3)"

# Set sink volume
if [ -z "$volume" ]; then
    pactl set-sink-volume "$new_active_sink" 100%
else
    pactl set-sink-volume "$new_active_sink" "$volume"
fi

in_profile="$(echo "$profile" | cut -f 2)"
out_profile="$in_profile"

if [ -z "$in_profile" ]; then
    # No profile found, connect directly to sink
    pw-link "${output_node}L" "${new_active_sink}:playback_FL"
    pw-link "${output_node}R" "${new_active_sink}:playback_FR"

    message="$(~/.scripts/audio/active_sink_nick.sh)"
else
    # Connect new effects profile to sink
    pw-link "${out_profile}:Output L" "${new_active_sink}:playback_FL"
    pw-link "${out_profile}:Output R" "${new_active_sink}:playback_FR"

    # Connect loudness to profile
    pw-link "${output_node}L" "${in_profile}:Input L"
    pw-link "${output_node}R" "${in_profile}:Input R"

    message="$in_profile"

    # Connect sub profile and sink if any
    sub_profile="$(cat ~/.config/myeffects/sub_profiles.txt | grep "^$in_profile")"
    if [ -n "$sub_profile" ]; then
        sub_sink="$(echo "$sub_profile" | cut -f 2)"
        sub_volume="$(echo "$sub_profile" | cut -f 4)"

        # Set sink volume
        if [ -z "$sub_volume" ]; then
            pactl set-sink-volume "$sub_sink" 100%
        else
            pactl set-sink-volume "$sub_sink" "$sub_volume"
        fi

        in_sub_profile="$(echo "$sub_profile" | cut -f 3)"
        out_sub_profile="$in_sub_profile"

        # Connect new effects profile to sink
        pw-link "${out_sub_profile}:Output L" "${sub_sink}:playback_FL"
        pw-link "${out_sub_profile}:Output R" "${sub_sink}:playback_FR"

        # Connect loudness to profile
        pw-link "${output_node}L" "${in_sub_profile}:Input L"
        pw-link "${output_node}R" "${in_sub_profile}:Input R"
    fi
fi

echo "$in_profile" > /tmp/active_profile

pkill -RTMIN+1 waybar
pkill -RTMIN+5 waybar

notify-send --expire-time 3000 "Audio: $message"

unlock
