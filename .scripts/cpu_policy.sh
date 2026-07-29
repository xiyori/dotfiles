#!/bin/bash

echo "$1" | tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference
