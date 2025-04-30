#!/bin/bash

endtime=$(date -ud "5 seconds" +%s%N)

max_level=0
while read -r line; do
    if [[ $(date -u +%s%N) -ge "$endtime" ]]; then
        echo $max_level
        exit 0
    fi
    if [ -z "$line" ]; then
        continue
    fi
    level="$(printf "%d\n" "0x$(echo "$line" | cut -d " " -f 3)")"
    if  [[ "$level" -gt "$max_level" ]]; then
        max_level="$level"
    fi
done < <(amidi -p "hw:0,0" -d)

echo $max_level
exit 1
