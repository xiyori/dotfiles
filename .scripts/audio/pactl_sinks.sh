#!/bin/bash

pactl list short sinks | grep -v "myeffects_sink" | grep -v "gain_sink"
