#!/bin/bash

output_node="LSP Loudness Compensator Stereo"
midi_bridge="Midi-Bridge:Virtual Raw MIDI 0-0VirMIDI 0-0"

pw-link "${midi_bridge} (capture)" "${output_node}:events-in"
pw-link "${output_node}:events-out" "${midi_bridge} (playback)"

if [ -z "$1" ]; then
    pw-link "myeffects_sink:monitor_FL" "${output_node}:Input L"
    pw-link "myeffects_sink:monitor_FR" "${output_node}:Input R"
fi
