#!/bin/python

import json
import sys

def get_json_command(command):
    import subprocess

    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE)
    return json.loads(result.stdout)


def run_command(command):
    # Run the custom command
    import subprocess

    # print(command, file=sys.stderr)
    subprocess.run(command, shell=True)


active_workspace = get_json_command("hyprctl -j activeworkspace")
workspaces = get_json_command("hyprctl -j workspaces")
direction = sys.argv[1]
ex_id = active_workspace["id"]
for workspace in workspaces:
    if workspace["monitorID"] == active_workspace["monitorID"]:
        if direction == "prev" and workspace["id"] < ex_id:
            run_command("hyprctl dispatch workspace m-1")
            exit(0)
        if direction == "next" and workspace["id"] > ex_id:
            run_command("hyprctl dispatch workspace m+1")
            exit(0)

if direction == "next":
    run_command("hyprctl dispatch workspace empty")

