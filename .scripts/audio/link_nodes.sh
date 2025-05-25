#!/bin/bash

pw-link "Big Meter:events-out" "Midi-Bridge:Virtual Raw MIDI 0-0VirMIDI 0-0 (playback)"
pw-link "Midi-Bridge:Virtual Raw MIDI 0-0VirMIDI 0-0 (capture)" "LSP Loudness Compensator Stereo:events-in"

pw-link "myeffects_sink:monitor_FL" "Big Meter:input_1"
pw-link "myeffects_sink:monitor_FR" "Big Meter:input_2"

pw-link "myeffects_sink:monitor_FL" "gain_sink:playback_FL"
pw-link "myeffects_sink:monitor_FR" "gain_sink:playback_FR"

pw-link "gain_sink:monitor_FL" "LSP Loudness Compensator Stereo:Input L"
pw-link "gain_sink:monitor_FR" "LSP Loudness Compensator Stereo:Input R"
