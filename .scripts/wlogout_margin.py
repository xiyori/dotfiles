#!/usr/bin/python

import json
import sys

info = json.load(sys.stdin)
for monitor in info:
    if monitor["focused"]:
        print(int(monitor["height"] / monitor["scale"] * 0.37))
        exit(0)
print(300)
