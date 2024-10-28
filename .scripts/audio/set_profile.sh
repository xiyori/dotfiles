#!/bin/bash

output_node="LSP Loudness Compensator Stereo"
~/.scripts/audio/remove_old_profile.sh "${output_node}:Output L"
~/.scripts/audio/remove_old_profile.sh "${output_node}:Output R"

profile="$1"
pw-link "${output_node}:Output L" "${profile}:Input L"
pw-link "${output_node}:Output R" "${profile}:Input R"
