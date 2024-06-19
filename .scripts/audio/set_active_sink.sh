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

get_sink_profile() {
    profile="$(cat ~/.config/myeffects/profiles.txt | grep "$1" | cut -f 2)"
    if [ -z "$profile" ]; then
        echo "$output_node"
    else
        echo "$profile"
    fi
}

if ! pactl list clients | grep "LSP Loudness Compensator Stereo" > /dev/null 2>&1; then
    notify-send --expire-time 3000 "Error: Carla not started"
    exit 0
fi

active_sink="$(~/.scripts/audio/get_active_sink.sh)"
new_active_sink="$1"

# Disconnect the pipeline to avoid volume spikes
~/.scripts/audio/remove_old_profile.sh "myeffects_sink:monitor_FL"
~/.scripts/audio/remove_old_profile.sh "myeffects_sink:monitor_FR"

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
