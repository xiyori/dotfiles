#!/bin/bash

amidi -l | sed -n '2 p' | tr -s " " | cut -d " " -f 2
