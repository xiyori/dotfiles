#!/bin/sh

layout_f=/tmp/kb_layout

case $(cat "$layout_f") in 
  *English*)
    # hyprctl keyword input:kb_layout ru
    hyprctl switchxkblayout at-translated-set-2-keyboard 1
    hyprctl switchxkblayout www.hfd.cn-akko-keyboard-1 1
    hyprctl switchxkblayout glorious-gmmk-pro-ansi 1
    hyprctl switchxkblayout hfd.cn-usb-device-2 1
    echo "{\"text\": \"ru\",\"tooltip\": \"Russian\"}" > $layout_f
    ;;
  *Russian*)
    # hyprctl keyword input:kb_layout us
    hyprctl switchxkblayout at-translated-set-2-keyboard 0
    hyprctl switchxkblayout www.hfd.cn-akko-keyboard-1 0
    hyprctl switchxkblayout glorious-gmmk-pro-ansi 0
    hyprctl switchxkblayout hfd.cn-usb-device-2 0
    echo "{\"text\": \"en\",\"tooltip\": \"English (US)\"}" > $layout_f
    ;;
esac

pkill -RTMIN+2 waybar
