#!/bin/bash

pactl list short sinks | grep -v "myeffects_sink" | grep -v "effect_input.virtual-surround-7.1-hesuvi" | grep -v "alsa_output.pci-0000_00_1f.3.iec958-stereo" | cut -f 2
