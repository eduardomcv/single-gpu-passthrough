#!/bin/bash
set -x

source "/etc/libvirt/hooks/kvm.conf"

# Stop display manager
systemctl --user -M eduardo@ stop plasma*
systemctl stop display-manager

# Unbind VTconsoles: might not be needed
echo 0 > /sys/class/vtconsole/vtcon0/bind
# echo 0 > /sys/class/vtconsole/vtcon1/bind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2 

# Unbind EFI Framebuffer
# echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Detach GPU devices from host
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Unload kernel modules
modprobe -r amdgpu
modprobe -r snd_hda_intel

# Load vfio module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
