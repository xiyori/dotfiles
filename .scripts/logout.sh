#!/bin/sh
pkill wlogout || wlogout --protocol layer-shell -b 4 -T 400 -B 400
