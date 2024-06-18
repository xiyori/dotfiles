#!/bin/bash

get_all_sinks() {
    pactl list short sinks | grep -v "myeffects_sink" | grep -v "alsa_output.pci-0000_00_1f.3.iec958-stereo" | cut -f 2
}
