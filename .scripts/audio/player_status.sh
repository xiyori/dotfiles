#!/bin/bash

case $(~/.scripts/audio/player.sh status 2> /dev/null) in
  Playing)
    state="1"
  ;;
  Paused)
    state="2"
  ;;
  *)
    state="0"
  ;;
esac

echo "$state" > /tmp/player_status
