#!/bin/bash
set -x

source "/etc/libvirt/hooks/kvm.conf"

# Attach GPU devices to host
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# Unload vfio module
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Load AMD kernel module
modprobe amdgpu
modprobe snd_hda_intel

# Rebind framebuffer to host
# echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Bind VTconsoles: might not be needed
echo 1 >/sys/class/vtconsole/vtcon0/bind
# echo 1 > /sys/class/vtconsole/vtcon1/bind

# Restart Display Manager
systemctl start display-manager
