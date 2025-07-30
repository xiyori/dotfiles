#!/bin/bash

q="$(swww query)"
echo "${q#*\: image\: }"
