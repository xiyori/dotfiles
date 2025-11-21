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

[[ "$(cat /tmp/low_latency)" == "low_latency" ]] || [[ "$(cat /tmp/auto_gain_enabled)" -eq 1 ]] && exit 0

flag=0
i=0
while [[ "$flag" -eq 0 && "$i" -lt 20 ]]; do
    volume="$(pactl get-sink-volume myeffects_sink | ~/.scripts/audio/get_pactl_volume.sh)"
    n_non_browser="$(pactl list sink-inputs | awk '/Corked:|application.name / {print $0};' | grep --after-context 1 "Corked: no" | grep "application.name" | grep -v "LibreWolf" | grep -v "Firefox" | wc -l)"
    active_sources="$(pactl list sink-inputs | awk '/Corked:|Volume:|media.name / {print $0};' | grep --after-context 2 "Corked: no" | grep --before-context 1 -e " - YouTube" -e "AudioStream")"

    unset new_volume
    if [[ "$(echo "$active_sources" | wc -l)" -eq 2 && "$n_non_browser" -eq 0 ]]; then
        new_volume="$(echo "$active_sources" | ~/.scripts/audio/get_pactl_volume.sh)"
    fi

    if [[ -z "$new_volume" ]]; then
        new_volume="0"
    else
        flag=1
    fi

    new_volume="$(bc -l <<< "x=-($new_volume); if(x<1) print 0; x")"

    if (( $(echo "$volume != $new_volume" | bc -l) )); then
        pactl set-sink-volume myeffects_sink "${new_volume}db"
        echo "$new_volume" > /tmp/auto_gain
        pkill -RTMIN+2 waybar
    else
        flag=0
    fi

    if [[ "$i" -lt 10 ]]; then
        sleep 0.1
    else
        sleep 1
    fi
    i=$(( i + 1 ))
done

unlock
