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

output_node="$([[ "$(cat /tmp/low_latency)" == "low_latency" ]] && echo "myeffects_sink:monitor_F" || echo "LSP Loudness Compensator Stereo:Output ")"

if ! pactl list clients | grep -q "LSP Loudness Compensator Stereo" ; then
    exit 0
fi
# if [[ "$(ps -o etimes= -p "$(pgrep carla)")" -lt 7 ]]; then
#     exit 0
# fi

active_sinks="$(~/.scripts/audio/list_active_sinks.sh)"
new_active_sink="$1"
profile="$2"

# Disconnect profile(s) from loudness
~/.scripts/audio/remove_output_links.sh "${output_node}"

# Disconnect profile from sink(s)
for active_sink in $active_sinks ; do
    ~/.scripts/audio/remove_input_links.sh "${active_sink}:playback"
done

volume="$(echo "$profile" | cut -f 3)"

# Set sink volume
if [[ -z "$volume" ]]; then
    pactl set-sink-volume "$new_active_sink" 100%
else
    pactl set-sink-volume "$new_active_sink" "$volume"
fi

in_port="$(echo "$profile" | cut -f 4)"
out_port="$(echo "$profile" | cut -f 5)"

profile_name="$(echo "$profile" | cut -f 2)"
in_profile="${profile_name}:${in_port:-Input }"
out_profile="${profile_name}:${out_port:-Output }"

if [[ -z "$profile_name" ]]; then
    # No profile found, connect directly to sink
    pw-link "${output_node}L" "${new_active_sink}:playback_FL"
    pw-link "${output_node}R" "${new_active_sink}:playback_FR"

    message="$(~/.scripts/audio/active_sink_nick.sh)"
else
    # Connect new effects profile to sink
    pw-link "${out_profile}L" "${new_active_sink}:playback_FL"
    pw-link "${out_profile}R" "${new_active_sink}:playback_FR"

    # Connect loudness to profile
    pw-link "${output_node}L" "${in_profile}L"
    pw-link "${output_node}R" "${in_profile}R"

    message=" $(cat ~/.config/myeffects/icons.txt | grep -F "$profile_name" | cut -f 2)  $profile_name"

    # Connect sub profile and sink if any
    sub_profile="$(cat ~/.config/myeffects/sub_profiles.txt | grep "^$profile_name")"
    if [[ -n "$sub_profile" ]]; then
        sub_sink="$(echo "$sub_profile" | cut -f 2)"
        sub_volume="$(echo "$sub_profile" | cut -f 4)"

        # Set sink volume
        if [[ -z "$sub_volume" ]]; then
            pactl set-sink-volume "$sub_sink" 100%
        else
            pactl set-sink-volume "$sub_sink" "$sub_volume"
        fi

        in_sub_port="$(echo "$sub_profile" | cut -f 5)"
        out_sub_port="$(echo "$sub_profile" | cut -f 6)"

        sub_profile_name="$(echo "$sub_profile" | cut -f 3)"
        in_sub_profile="${sub_profile_name}:${in_sub_port:-Input }"
        out_sub_profile="${sub_profile_name}:${out_sub_port:-Output }"

        # Connect new effects profile to sink
        pw-link "${out_sub_profile}L" "${sub_sink}:playback_FL"
        pw-link "${out_sub_profile}R" "${sub_sink}:playback_FR"

        # Connect profile to sub profile
        pw-link "${out_profile}L" "${in_sub_profile}L"
        pw-link "${out_profile}R" "${in_sub_profile}R"
    fi
fi

echo "$profile_name" > /tmp/active_profile
echo "$new_active_sink" > /tmp/active_sink
echo "$(~/.scripts/audio/active_sink_nick.sh)" > /tmp/active_sink_nick
~/.scripts/audio/mute_status.sh

pkill -RTMIN+1 waybar
pkill -RTMIN+5 waybar

notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Audio: $message"

unlock
