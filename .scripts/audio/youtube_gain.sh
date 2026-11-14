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

pactl list clients | grep -q "LSP Loudness Compensator Stereo" || exit 0

sleep 0.2

KEYWORD="- YouTube"
BROWSERS="LibreWolf|Firefox|Tor Browser|Chromium"

# max_vol=""

# Parse sink-inputs block-by-block and return: <id> <target_db> <current_db>
while read -r id target_vol current_vol; do
    # Only update if the current dB differs from the target dB
    if [[ -n "$current_vol" ]] && (( $(echo "$current_vol != $target_vol" | bc -l) )); then
        pactl set-sink-input-volume "$id" "${target_vol}db"
    fi

    # Track the highest target volume among all active browser streams
    # if [[ -z "$max_vol" ]] || (( $(echo "$target_vol > $max_vol" | bc -l) )); then
    #     max_vol="$target_vol"
    # fi
done < <(pactl list sink-inputs | awk -v kw="$KEYWORD" -v browsers="$BROWSERS" '
BEGIN {
    RS = "Sink Input #"
    FS = "\n"
}
NR > 1 {
    id = $1
    app = ""
    media = ""
    vol_db = ""

    for (i = 2; i <= NF; i++) {
        if ($i ~ /application\.name = /) {
            sub(/.*application\.name = "/, "", $i)
            sub(/".*/, "", $i)
            app = $i
        }
        else if ($i ~ /media\.name = /) {
            sub(/.*media\.name = "/, "", $i)
            sub(/".*/, "", $i)
            media = $i
        }
        else if ($i ~ /^[[:space:]]*Volume:/) {
            # Extracts the dB value (e.g., "0.00" or "-6.50")
            if (match($i, /[-+]?[0-9]+\.[0-9]+[[:space:]]*dB/)) {
                vol_db = substr($i, RSTART, RLENGTH)
                sub(/[[:space:]]*dB/, "", vol_db)
            }
        }
    }

    # Check if the stream belongs to a browser
    if (app ~ browsers) {
        target = (index(media, kw) > 0) ? 8 : 0
        print id, target, vol_db
    }
}
')

# Default to 0 if no browser streams are currently active
# max_vol=${max_vol:-0}
# prev_max=$(cat /tmp/auto_gain 2>/dev/null)

# Update state file and refresh bar once if any volume changed or max_vol shifted
# if [[ "$max_vol" != "$prev_max" ]]; then
#     echo "$max_vol" > /tmp/auto_gain
#     ~/.scripts/bar_refresh autogain
# fi

unlock
