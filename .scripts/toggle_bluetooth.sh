#!/bin/sh
# Script by AmitGolden from https://github.com/AmitGolden/dotfiles/tree/main

state=$(bluetoothctl -- show | grep Powered | awk '{ print $2 }')

if [[ $state == 'yes' ]]; then
    bluetoothctl -- power off
else
    bluetoothctl -- power on
fi
