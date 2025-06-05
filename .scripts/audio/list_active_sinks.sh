#!/bin/bash

~/.scripts/audio/pactl_sinks.sh | grep RUNNING | cut -f 2
