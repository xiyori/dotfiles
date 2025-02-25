#!/bin/bash

pactl list short sinks | grep -v "myeffects_sink" | grep -v "alsa_output.pci-0000_01_00.1.hdmi-stereo" | grep -v "alsa_output.usb-Generic_USB_Audio-00.HiFi__SPDIF__sink" | grep -v "alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink" | grep -v "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink" | grep -v "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH31320DN0JKLTAY-00.analog-stereo" | cut -f 2
