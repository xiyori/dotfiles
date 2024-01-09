#!/bin/bash

if hyprctl monitors | grep "Monitor HDMI-A-1"; then
    hyprctl keyword monitor "eDP-1,disable"
fi
