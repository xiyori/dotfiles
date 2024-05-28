#!/usr/bin/python

import json
import sys

omit = ["video-bus", "power-button", "sleep-button", "system-control", "consumer-control", "hotkeys", "moondrop", "mouse", "keyboard"]

devices = json.load(sys.stdin)
for keyboard in devices["keyboards"]:
    for keyword in omit:
        if keyword in keyboard["name"]:
            break
    else:
        print(keyboard["name"])
