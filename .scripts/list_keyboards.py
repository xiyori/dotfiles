#!/usr/bin/python

import json
import sys

omit = ["video-bus", "power-button", "system-control", "consumer-control", "hotkeys"]

devices = json.load(sys.stdin)
for keyboard in devices["keyboards"]:
    for keyword in omit:
        if keyword in keyboard["name"]:
            break
    else:
        print(keyboard["name"])
