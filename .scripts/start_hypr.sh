#!/bin/bash

case "$(tail -1 /tmp/failed_hyprstart)" in
    clear)
        Hyprland
        echo "fail" >> /tmp/failed_hyprstart
    ;;
    fail)
        echo "clear" >> /tmp/failed_hyprstart
        exec bash
    ;;
esac
