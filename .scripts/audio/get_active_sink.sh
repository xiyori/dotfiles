#!/bin/bash

pactl list short sinks | grep RUNNING | grep -v "myeffects_sink" | grep -v "effect_input.virtual-surround-7.1-hesuvi" | head -1 | cut -f 2
