#!/bin/bash

list_input_ports() {
    pw-link -Iil "" "$1" | grep -v "|<-" | cut -f 2 -d ":" | grep -v "events" | grep -v "monitor"
}

list_output_ports() {
    pw-link -Iol "$1" | grep -v "|->" | cut -f 2 -d ":" | grep -v "events" | grep -v "monitor"
}

remove_input_links() {
    for link in $(pw-link -Iil "" "$1" | grep "|<-" | grep -vi "midi" | awk '{ print $1 }') ; do
        pw-link -d "$link"
    done
}

remove_output_links() {
    for link in $(pw-link -Iol "$1" | grep "|->" | grep -vi "midi" | awk '{ print $1 }') ; do
        pw-link -d "$link"
    done
}

source_node="LSP Loudness Compensator Stereo"
theater_node="Home Theater"
sink_node="alsa_output.usb-MOTU_UltraLite-mk5_UL5LFF1F60-00.pro-output-0"

if [[ "$(pactl get-default-sink)" == "$theater_node" ]]; then
    # Disable theater mode
    remove_output_links "$theater_node"
    pactl set-default-sink "myeffects_sink"

    sleep 0.25
    ~/.scripts/audio/detect_sink_change.sh
else
    active_sinks="$(~/.scripts/audio/list_active_sinks.sh)"

    # Disconnect profile(s) from loudness
    remove_output_links "$source_node"

    # Disconnect profile from sink(s)
    for active_sink in $active_sinks ; do
        remove_input_links "$active_sink"
    done

    # Enable theater mode
    pactl set-default-sink "$theater_node"
    readarray -t out_ports < <(list_output_ports "$theater_node")
    readarray -t in_ports < <(list_input_ports "$sink_node")

    for (( i=0; i<${#out_ports[@]}; i++ )); do
        pw-link "${theater_node}:${out_ports[i]}" "${sink_node}:${in_ports[i]}"
    done
fi
