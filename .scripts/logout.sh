#!/bin/bash
margin=$(hyprctl monitors -j | ~/.scripts/wlogout_margin.py)
pkill wlogout || wlogout --protocol layer-shell -b 4 -T $margin -B $margin
