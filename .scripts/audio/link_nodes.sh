#!/bin/bash

output_node="LSP Loudness Compensator Stereo"

# pw-link "Big Meter:events-out" "Midi-Bridge:Virtual Raw MIDI 0-0VirMIDI 0-0 (playback)"
pw-link "Midi-Bridge:Virtual Raw MIDI 0-0VirMIDI 0-0 (capture)" "${output_node}:events-in"

# pw-link "myeffects_sink:monitor_FL" "Big Meter:input_1"
# pw-link "myeffects_sink:monitor_FR" "Big Meter:input_2"

pw-link "myeffects_sink:monitor_FL" "gain_sink:playback_FL"
pw-link "myeffects_sink:monitor_FR" "gain_sink:playback_FR"

if [ -z "$1" ]; then
    pw-link "gain_sink:monitor_FL" "${output_node}:Input L"
    pw-link "gain_sink:monitor_FR" "${output_node}:Input R"
fi
