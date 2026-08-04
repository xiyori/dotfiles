#!/bin/bash

hyprctl eval 'hl.monitor({
    output = "eDP-1",
    mode = "2880x1800@60",
    position = "0x0",
    scale = 1.8,
})'
