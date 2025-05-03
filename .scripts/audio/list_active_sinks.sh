#!/bin/bash

pactl list short sinks | grep RUNNING | grep -v "myeffects_sink" | grep -v "gain_sink" | cut -f 2
