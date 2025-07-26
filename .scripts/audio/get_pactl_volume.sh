#!/bin/bash

head -1 | cut -d "/" -f 3 | cut -d "d" -f 1 | xargs
