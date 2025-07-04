#!/usr/bin/env bash

# lspci | grep -E 'VGA|3D'
# lspci | grep -E 'VGA|3D' | cut -d" " -f1
# Warning: using early-loading for NVIDIA drivers with dracut may change GPUs ID
# # for example Fedora on my Lenovo 5i (intel 10750 + RTX 2060)
# # without early loading
# 00:02.0 VGA compatible controller: Intel Corporation CometLake-H GT2 [UHD Graphics] (rev 05)
# 01:00.0 VGA compatible controller: NVIDIA Corporation TU106M [GeForce RTX 2060 Mobile] (rev a1)
# ~ with xterm-kitty
#  .912ns fsh ❯ ls -l /dev/dri/by-path
# total 0
# lrwxrwxrwx. 1 root root  8 fev 16 12:40 pci-0000:00:02.0-card -> ../card0
# lrwxrwxrwx. 1 root root 13 fev 16 12:40 pci-0000:00:02.0-render -> ../renderD128
# lrwxrwxrwx. 1 root root  8 fev 16 12:40 pci-0000:01:00.0-card -> ../card1
# lrwxrwxrwx. 1 root root 13 fev 16 12:40 pci-0000:01:00.0-render -> ../renderD129
multigpu() {
    local gpu_count
    local -a gpus_array
    gpu_count="$(lspci | grep -Ec 'VGA|3D')"
    mapfile gpus_array < <(lspci | grep -E 'VGA|3D' | cut -d" " -f1)

    ls -l /dev/dri/by-path

    echo "/dev/dri/pci-0000:06:00.0-card ~/.config/hypr/card"

    echo "env = WLR_DRM_DEVICES,~/.config/hypr/card"
    # or with a fall back

    echo "env = WLR_DRM_DEVICES,~/.config/hypr/card:~/.config/hypr/otherCard"
}
multigpu
