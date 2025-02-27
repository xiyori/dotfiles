#!/bin/bash

current_volume="0x$(cat /tmp/loudness)"

case "$1" in
  up)
    delta="0x02"
  ;;
  down)
    delta="-0x02"
  ;;
  coarse_up)
    delta="0x0a"
  ;;
  coarse_down)
    delta="-0x0a"
  ;;
  mute)
    for active_sink in $(~/.scripts/audio/list_active_sinks.sh) ; do
        pactl set-sink-mute "$active_sink" toggle
    done
    exit 0
  ;;
esac

new_volume_dec="$(awk '$0<7{$0=7}$0>127{$0=127}1' <<<$((current_volume + delta)))"
new_volume="$(printf "%X" "$new_volume_dec")"
device="$(amidi -l | sed -n '2 p' | tr -s " " | cut -d " " -f 2)"
amidi -p "$device" -S "B2 07 $new_volume"  # send volume control to MIDI channel 3
echo "$new_volume" > /tmp/loudness
