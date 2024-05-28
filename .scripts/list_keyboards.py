#!/usr/bin/python

import json
import sys

# omit = ["video-bus", "power-button", "sleep-button", "system-control", "consumer-control", "hotkeys", "moondrop", "mouse", "keyboard"]

devices = json.load(sys.stdin)
for keyboard in devices["keyboards"]:
    if keyboard["main"]:
        print(keyboard["name"])
