#!/bin/bash

! pw-link -l | grep "|<- LSP Loudness Compensator Stereo:Output" > /dev/null && ~/.scripts/audio/next_audio_sink.sh
