#!/bin/sh

layout_f=/tmp/kb_layout

case $(cat "$layout_f") in 
  *English*)
    # hyprctl keyword input:kb_layout ru
    hyprctl devices -j | ~/.scripts/list_keyboards.py | while read name; do
        hyprctl switchxkblayout $name 1
    done
    echo "{\"text\": \"ru\",\"tooltip\": \"Russian\"}" > $layout_f
    ;;
  *Russian*)
    # hyprctl keyword input:kb_layout us
    hyprctl devices -j | ~/.scripts/list_keyboards.py | while read name; do
        hyprctl switchxkblayout $name 0
    done
    echo "{\"text\": \"en\",\"tooltip\": \"English (US)\"}" > $layout_f
    ;;
esac

pkill -RTMIN+2 waybar
