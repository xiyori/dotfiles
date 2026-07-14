#!/bin/bash

source_node="LSP Loudness Compensator Stereo"
midi_device="$(~/.scripts/audio/midi_device.sh | cut -d ":" -f 2 | tr "," "-")"
midi_out="$(pw-link -Iol "Midi-Bridge" | grep "$midi_device" | xargs | cut -d " " -f 2-)"
midi_in="$(pw-link -Iil "" "Midi-Bridge" | grep "$midi_device" | xargs | cut -d " " -f 2-)"

pw-link "$midi_out" "${source_node}:events-in"
pw-link "${source_node}:events-out" "$midi_in"

if [[ -z "$1" ]]; then
    pw-link "myeffects_sink:monitor_FL" "${source_node}:Input L"
    pw-link "myeffects_sink:monitor_FR" "${source_node}:Input R"
fi
