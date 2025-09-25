#!/bin/python

import os
import sys
import math

LEVEL_BOUNDS = (-72, 24)
GAMMA = 0.01
TARGET_LUFS = -7.5
THRESHOLD_LUFS = -35
MAX_GAIN = 25  # db
COOLDOWN = math.log(0.5, 1 - GAMMA)


def run_command(command):
    # Run the custom command
    import subprocess

    # print(command, file=sys.stderr)
    subprocess.run(command, shell=True)


def send_notif():
    run_command("notify-send -e -h boolean:SWAYNC_BYPASS_DND:true -u low \"Auto Gain: Off\"")


def set_gain(gain: float):
    print("set ", gain)
    run_command(f"pactl set-sink-volume myeffects_sink \"{gain}db\" ; echo \"{gain}\" > /tmp/auto_gain")


def main():
    average_lufs = None
    with open("/tmp/auto_gain", "r") as fp:
        current_gain = float(fp.read())
    iter = 0
    while True:
        line = sys.stdin.readline()
        try:
            level = int(line.strip().split(" ")[-1], 16)
        except ValueError:
            continue
        level_db = (
            level / 128 * (LEVEL_BOUNDS[1] - LEVEL_BOUNDS[0])
            + LEVEL_BOUNDS[0]
            - current_gain
        )
        if level_db > THRESHOLD_LUFS:
            if average_lufs is None:
                average_lufs = level_db
            average_lufs = (1 - GAMMA) * average_lufs + GAMMA * level_db
            iter += 1
        # print(average_lufs, level_db)
        if average_lufs is None or iter < COOLDOWN:
            continue
        new_gain = int(max(0, min(MAX_GAIN, TARGET_LUFS - average_lufs)) * 2) / 2
        if new_gain == current_gain:
            continue
        if current_gain == 0 and average_lufs > THRESHOLD_LUFS:
            current_gain = new_gain
            set_gain(current_gain)
            # if current_gain == 0:
            #     send_notif()
            #     break
            run_command("pkill -RTMIN+2 waybar")
        # elif new_gain < current_gain:
        elif current_gain != 0:
            current_gain = new_gain
            set_gain(current_gain)
            # if current_gain == 0:
            #     send_notif()
            #     break
            run_command("pkill -RTMIN+2 waybar")


if __name__ == "__main__":
    main()
