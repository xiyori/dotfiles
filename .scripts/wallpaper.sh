#!/usr/bin/bash

case $(swww query) in 
  *cirno.jpg)
    new_image="$WALLPAPER1"
  ;;
  *)
    new_image="$WALLPAPER2"
  ;;
esac

swww img "$new_image" -t wipe --transition-angle 30
