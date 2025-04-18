#!/bin/bash

threshold=10  # 10db
max_boost=6   # 6db
distance_thresh=20
count_thresh=5

function set_gain {
    gain_raw="$(bc -l <<< "$1 * 100 / $threshold")"
    gain_raw="$(printf '%.0f\n' "$gain_raw")"
    gain_hex="$(printf "%X" "$gain_raw")"
    device="$(~/.scripts/audio/midi_device.sh)"
    amidi -p "$device" -S "B1 07 $gain_hex"  # send volume control to MIDI channel 2
    echo "$1" > /tmp/auto_gain
}

function level2gain {
    tmp="$(bc -l <<< "2 * 20 * l(127 / $1) / l(10)")"
    printf '%.1f\n' "$(bc -l <<< "$(printf '%.0f\n' "$tmp") / 2")"
}

pkill -RTMIN+2 waybar

max_level=0
gain_db=0
level_history=()
distance_history=()
distance=0
while read -r line; do
    if [ -z "$line" ]; then
        continue
    fi

    level="$(printf "%d\n" "0x$(echo "$line" | cut -d " " -f 3)")"

    if [[ "$level" -gt "$max_level" ]]; then
        for i in "${!distance_history[@]}" ; do
            distance_history[$i]=$(( distance_history[$i] + distance ))
        done

        while [[ "${distance_history[0]}" -ge "$distance_thresh" ]]; do
            level_history=("${level_history[@]:1}")
            distance_history=("${level_history[@]:1}")
        done

        level_history+=("$level")
        distance_history+=(0)
        distance=0
        
        max_value=0
        for level in "${level_history[@]}" ; do
            if  [[ "$level" -gt "$max_value" ]]; then
                max_value="$level"
            fi
        done

        # echo "${#level_history[@]}" 

        if [[ "${#level_history[@]}" -ge "$count_thresh" ]] && [[ "$max_value" -gt "$max_level" ]]; then
            max_level="$max_value"
            new_gain_db="$(level2gain "$max_level")"
            if (( $(echo "$gain_db == 0" | bc -l) )) && (( $(echo "$new_gain_db < $threshold" | bc -l) )); then
                gain_db="$new_gain_db"
                if (( $(echo "$gain_db > $max_boost" | bc -l) )); then
                    gain_db="$max_boost"
                fi
                set_gain "$gain_db"

                pkill -RTMIN+2 waybar
            elif (( $(echo "$new_gain_db < $gain_db" | bc -l) )); then
                gain_db="$new_gain_db"
                set_gain "$gain_db"

                pkill -RTMIN+2 waybar

                if (( $(echo "$gain_db == 0" | bc -l) )); then
                    notify-send --expire-time 3000 "Auto Gain: Off"
                    break
                fi
            fi
        fi
    fi
    distance=$(( distance + 1 ))
done < <(amidi -p "hw:0,0" -d)

pkill amidi
