#!/bin/bash
set -x

# Unload vfio module
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio
  
# Rebind GPU
virsh nodedev-reattach pci_0000_03_00_0
virsh nodedev-reattach pci_0000_03_00_1

# Rebind Audio devices
virsh nodedev-reattach pci_0000_00_1f_0
virsh nodedev-reattach pci_0000_00_1f_3
virsh nodedev-reattach pci_0000_00_1f_4
virsh nodedev-reattach pci_0000_00_1f_5

# Reload AMD modules
modprobe amdgpu

# Rebind framebuffer to host
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# Restart Display Manager
systemctl start display-manager
