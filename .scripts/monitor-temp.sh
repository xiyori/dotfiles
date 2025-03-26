#!/bin/bash
ln -sf /sys/devices/platform/coretemp.0/hwmon/* /tmp/hwmon4
ln -sf /sys/devices/platform/nct6687.2592/hwmon/* /tmp/hwmon5

mkdir -p /tmp/monitor-temp
echo 30000 > /tmp/monitor-temp/temp_gpu
echo 30000 > /tmp/monitor-temp/temp_max_gpu_cpu
echo 30000 > /tmp/monitor-temp/temp_cpu_max_avg
printf '30000\n%.0s' {1..10} > /tmp/monitor-temp/temp_cpu_history
while : ; do
    temp_gpu="$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)"
    temp_gpu="$((temp_gpu * 1000))"
    echo "$temp_gpu" > /tmp/monitor-temp/temp_gpu

    temp_cpu="$(cat /tmp/hwmon4/temp1_input)"
    echo "$temp_cpu" > /tmp/monitor-temp/temp_cpu
    echo "$((temp_gpu > temp_cpu ? temp_gpu : temp_cpu))" > /tmp/monitor-temp/temp_max_gpu_cpu

    tail -n +2 /tmp/monitor-temp/temp_cpu_history > /tmp/monitor-temp/temp_cpu_history.tmp && mv /tmp/monitor-temp/temp_cpu_history.tmp /tmp/monitor-temp/temp_cpu_history
    echo "$temp_cpu" >> /tmp/monitor-temp/temp_cpu_history

    max=0
    while read N; do
        if (( N > max )); then
            max="$N"
        fi
    done < /tmp/monitor-temp/temp_cpu_history
    echo "$max" > /tmp/monitor-temp/temp_cpu_max_avg

    sleep 5
done
