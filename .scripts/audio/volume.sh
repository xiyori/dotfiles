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
esac

volume="$(cat /tmp/loudness)"
new_volume="$(awk '$0<30{$0=30}$0>90{$0=90}1' <<<$((volume + delta)))"
new_volume_raw=$((2 * new_volume - 53))
new_volume_hex="$(printf "%X" "$new_volume_raw")"
device="$(~/.scripts/audio/midi_device.sh)"
amidi -p "$device" -S "B2 07 $new_volume_hex"  # send volume control to MIDI channel 3
echo "$new_volume" > /tmp/loudness

unlock
