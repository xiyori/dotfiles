#!/usr/bin/python

import json
import sys

info = json.load(sys.stdin)
if info:
    print(int(info["logical"]["height"] * 0.37))
    exit(0)
print(300)
