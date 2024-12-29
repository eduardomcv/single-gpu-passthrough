#!/bin/bash

set -x

source "/etc/libvirt/hooks/kvm.conf"

# Stop kde plasma services
systemctl --user -M eduardo@ stop plasma*

# Stop display manager
systemctl stop display-manager

# Unbind VTconsoles
echo 0 >/sys/class/vtconsole/vtcon0/bind
echo 0 >/sys/class/vtconsole/vtcon1/bind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

# Unbind EFI Framebuffer
# echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Detach devices from host
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_ONBOARD_CARD
virsh nodedev-detach $VIRSH_ONBOARD_AUDIO
virsh nodedev-detach $VIRSH_ONBOARD_SMBUS
virsh nodedev-detach $VIRSH_ONBOARD_SPI

# Unload kernel modules
modprobe -r amdgpu
modprobe -r snd_hda_intel

# Load vfio modules
modprobe vfio_pci
modprobe vfio
modprobe vfio_iommu_type1
