#!/bin/bash

grep -F -v "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH31320DN0JKLTAY-00.analog-stereo" | grep -F -v "effect_input.convolver"
