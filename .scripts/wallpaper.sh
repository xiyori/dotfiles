#!/usr/bin/bash

case $(swww query) in 
  *$WALLPAPER1)
    new_image="$WALLPAPER2"
  ;;
  *)
    new_image="$WALLPAPER1"
  ;;
esac

swww img "$new_image" -t wipe --transition-angle 30
