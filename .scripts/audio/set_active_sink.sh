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

### FUNCTIONS ###

list_input_ports() {
    pw-link -Iil "" "$1" | grep -v "|<-" | cut -f 2 -d ":" | grep -v "events" | grep -v "monitor"
}

list_output_ports() {
    pw-link -Iol "$1" | grep -v "|->" | cut -f 2 -d ":" | grep -v "events" | grep -v "monitor"
}

remove_input_links() {
    for link in $(pw-link -Iil "" "$1" | grep "|<-" | grep -vi "midi" | awk '{ print $1 }') ; do
        pw-link -d "$link"
    done
}

remove_output_links() {
    for link in $(pw-link -Iol "$1" | grep "|->" | grep -vi "midi" | awk '{ print $1 }') ; do
        pw-link -d "$link"
    done
}

active_sink_nick() {
    pactl list sinks | sed -n "/$(~/.scripts/audio/get_active_sink.sh)/,/^$/p" 2> /dev/null | grep -F -e "node.nick" -e "media.name" | cut -d'=' -f 2 | xargs | tr -d '"'
}

# Simplest example is avoiding running multiple instances of script.
exlock_now || exit 1

output_node="LSP Loudness Compensator Stereo"

if ! pactl list clients | grep -q "$output_node" ; then
    exit 0
fi

active_sinks="$(~/.scripts/audio/list_active_sinks.sh)"
new_active_sink="$1"
profile="$2"

# Disconnect profile(s) from loudness
remove_output_links "$output_node"

# Disconnect profile from sink(s)
for active_sink in $active_sinks ; do
    remove_input_links "$active_sink"
done

volume="$(echo "$profile" | cut -f 2)"

# Set sink volume
if [[ -z "$volume" ]]; then
    pactl set-sink-volume "$new_active_sink" 100%
else
    pactl set-sink-volume "$new_active_sink" "$volume"
fi

first_node="$(echo "$profile" | cut -f 3)"

readarray -t sink_ports < <(list_input_ports "$new_active_sink")
readarray -t output_ports < <(list_output_ports "$output_node")

length="${#sink_ports[@]}"
i=0
while read node; do
    # Connect loudness to profile
    j=0
    while read in_port; do
        pw-link "${output_node}:${output_ports[j]}" "${node}:${in_port}"
        j=$(( j + 1 ))
    done < <(list_input_ports "$node")

    # Connect effects profile to sink
    while read out_port; do
        if (( i >= length )); then
            break
        fi
        pw-link "${node}:${out_port}" "${new_active_sink}:${sink_ports[i]}" 
        i=$(( i + 1 ))
    done < <(list_output_ports "$node")

    if [[ -z "$message" ]]; then
        message=" $(cat ~/.config/myeffects/icons.txt | grep -F "$node" | cut -f 2)  $node"
    fi

    if (( i >= length )); then
        break
    fi
done < <(echo "$profile" | cut -f "3-" | tr "\t" "\n")

if [[ -z "$first_node" ]]; then
    # No profile found, connect directly to sink
    for (( i=0; i<${#output_ports[@]}; i++ )); do
        if (( i >= length )); then
            break
        fi
        pw-link "${output_node}:${output_ports[i]}" "${new_active_sink}:${sink_ports[i]}"
    done

    message="$(active_sink_nick)"
fi

echo "$first_node" > /tmp/active_profile
echo "$new_active_sink" > /tmp/active_sink
echo "$(active_sink_nick)" > /tmp/active_sink_nick
~/.scripts/audio/muted_update.sh "$(pactl get-sink-mute "$new_active_sink" | grep -q "yes" && echo 1 || echo 0)"

pkill -RTMIN+1 waybar
pkill -RTMIN+5 waybar

notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low "Audio: $message"

unlock
