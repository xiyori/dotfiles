#!/bin/bash

muted="$(cat /tmp/muted)"
volume="$(cat /tmp/loudness)"
if (( muted == 1 )); then
    echo "󰖁"
elif (( volume > 83 )); then
    echo "󰝝"
elif (( volume >= 70 )); then
    echo "󰕾"
elif (( volume >= 60 )); then
    echo "󰖀"
else
    echo "󰕿"
fi
