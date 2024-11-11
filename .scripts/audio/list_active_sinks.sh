#!/bin/bash

pactl list short sinks | grep RUNNING | grep -v "myeffects_sink" | cut -f 2
