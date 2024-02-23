#!/usr/bin/python

import json
import sys

devices = json.load(sys.stdin)
for keyboard in devices["keyboards"]:
    print(keyboard["name"])
