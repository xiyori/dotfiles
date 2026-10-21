#!/bin/bash

~/.scripts/audio/pactl_sinks.sh | grep -v "Home Theater" | cut -f 2
