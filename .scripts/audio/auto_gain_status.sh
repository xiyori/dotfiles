#!/bin/bash

pgrep "gain_loop.sh" > /dev/null 2>&1 && echo "{\"text\":\"\",\"tooltip\":\"Auto Gain +$(cat /tmp/auto_gain)db\"}"
