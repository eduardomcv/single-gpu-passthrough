#!/bin/bash

set -x

source "/etc/libvirt/hooks/kvm.conf"

# Re-attach devices to host
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_ONBOARD_CARD
virsh nodedev-reattach $VIRSH_ONBOARD_AUDIO
virsh nodedev-reattach $VIRSH_ONBOARD_SMBUS
virsh nodedev-reattach $VIRSH_ONBOARD_SPI

# Unload vfio modules
modprobe -r vfio_iommu_type1
modprobe -r vfio_pci
modprobe -r vfio

# Load kernel modules
modprobe amdgpu
modprobe snd_hda_intel

# Rebind framebuffer to host
# echo "efi-framebuffer.0" >/sys/bus/platform/drivers/efi-framebuffer/bind

# Bind VTconsoles
echo 1 >/sys/class/vtconsole/vtcon0/bind
echo 1 >/sys/class/vtconsole/vtcon1/bind

# Restart pipewire audio
systemctl --user -M eduardo@ start pipewire
systemctl --user -M eduardo@ start pipewire-pulse

# Restart display manager
systemctl start display-manager
