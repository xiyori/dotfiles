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
    pactl set-sink-mute "$(~/.scripts/audio/get_active_sink.sh)" toggle
    exit 0
  ;;
esac

new_volume_dec="$(awk '$0<7{$0=7}$0>127{$0=127}1' <<<$((current_volume + delta)))"
new_volume="$(printf "%X" "$new_volume_dec")"
amidi -p "hw:0,0" -S "B2 07 $new_volume"  # send volume control to MIDI channel 3
echo "$new_volume" > /tmp/loudness
