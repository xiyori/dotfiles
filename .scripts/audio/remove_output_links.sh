#!/bin/bash

for link in $(pw-link -Iol "$1" | tail -n +2 | awk '{ print $1 }') ; do
    pw-link -d "$link"
done
