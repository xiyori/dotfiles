#!/bin/bash
alacritty --class "tty-flex,tty-flex" -o "window.dimensions.lines=10" -o "window.dimensions.columns=60" -o "font.size=10" -e tty-clock -C 4 -c -s -D -d 0 -a 50000000
