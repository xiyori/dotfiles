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

case "$1" in
  up)
    delta="1"
  ;;
  down)
    delta="-1"
  ;;
  coarse_up)
    delta="5"
  ;;
  coarse_down)
    delta="-5"
  ;;
  mute)
    for active_sink in $(~/.scripts/audio/list_active_sinks.sh) ; do
        pactl set-sink-mute "$active_sink" toggle
    done
    exit 0
  ;;
esac

volume="$(pactl get-sink-volume gain_sink | head -1 | cut -d "/" -f 3 | cut -d "d" -f 1 | xargs)"
new_volume="$(echo "$volume + $delta" | bc -l | awk '{print int($1)}' | awk '$0<-53{$0=-53}$0>7{$0=7}1')"
delta="$(bc -l <<< "$new_volume - $volume")"
pactl set-sink-volume gain_sink "+${delta}db"
echo $((new_volume + 83)) > /tmp/loudness

unlock
