#!/bin/bash
#
# Renable NVIDIA audio controller after suspend or video sleep such as screen autolock
# Need to the find the NVIDIA audio controller
#     lspci | grep -i nvidia
#          01:00.0 VGA compatible controller: NVIDIA Corporation GP106M [GeForce GTX 1060 Mobile] (rev a1)
#          01:00.1 Audio device: NVIDIA Corporation GP106 High Definition Audio Controller (rev a1)

[[ $UID = 0 ]] || exec sudo "$0"

echo 1 > '/sys/bus/pci/devices/0000:01:00.1/remove'
sleep 1
echo 1 > /sys/bus/pci/rescan
