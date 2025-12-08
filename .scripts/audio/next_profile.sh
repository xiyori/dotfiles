#!/bin/bash

active_sink="$(~/.scripts/audio/get_active_sink.sh)"
active_profile="$(cat /tmp/active_profile)"

while read -r profile; do
    # Save the first index in case the current default is the last in the list
    [[ -z "$first" ]] && first="$profile"
    # Subsequent pass, don't need continue above
    if [[ -n "$next" ]]; then
        new_active_profile="$profile"
        break
    fi
    if echo "$profile" | grep -q "$active_profile" ; then
        next=1
    fi
done < <(~/.scripts/audio/get_sink_profiles.sh "$active_sink")

[[ -z "$next" ]] && exit 0

# Here this method of making it circular is beneficial instead
[[ -z "$new_active_profile" ]] && new_active_profile="$first"

~/.scripts/audio/set_active_sink.sh "$active_sink" "$new_active_profile"
