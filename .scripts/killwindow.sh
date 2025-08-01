#!/bin/bash

hyprctl activeworkspace | grep "(Music)" && pkill -f "alacritty --class cmus"; hyprctl dispatch killactive
