#!/bin/bash

for link in $(pw-link -Iil "" "$1" | grep "|<-" | awk '{ print $1 }') ; do
    pw-link -d "$link"
done
