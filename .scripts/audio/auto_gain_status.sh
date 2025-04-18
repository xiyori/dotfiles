#!/bin/bash

pgrep "gain_loop.sh" > /dev/null 2>&1 && echo "{\"text\":\" +$(cat /tmp/auto_gain)db\",\"tooltip\":\"Auto Gain: On\"}"
