#!/usr/bin/bash

case $(swww query) in 
  *cirno.jpg)
    new_image="cirno_3.jpg"
  ;;
  *)
    new_image="cirno.jpg"
  ;;
esac

swww img ~/Pictures/wallpaper/$new_image -t wipe --transition-angle 30
