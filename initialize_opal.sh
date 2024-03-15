#!/bin/bash

set -ex

DEVICE="${1?Expected device}"

fdisk -l "$DEVICE" || true

smartctl -x "$DEVICE" || true

# Replace /dev/nvme1 with your actual drive path
sedutil-cli --initialsetup debug "$DEVICE"
sedutil-cli --enablelockingrange 0 debug "$DEVICE"
sedutil-cli --setlockingrange 0 lk debug "$DEVICE"
sedutil-cli --setmbrdone off debug "$DEVICE"
sedutil-cli --loadpbaimage debug ./UEFI64.img "$DEVICE"

echo "Now power off the drive and it should enter the weird state."