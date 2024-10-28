#!/bin/bash

pactl list short sinks | grep RUNNING | grep -v "myeffects_sink" | head -1 | cut -f 2
