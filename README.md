This version is modified for NVIDIA Jetson (L4T)

Linux headers required for the driver installer script are usually matched to `linux-headers-${uname -r}`. 

Not so with Jetson Tegra devices, where headers are provided in the unified package `nvidia-l4t-kernel-headers`. 

So if 'tegra' is found in the `uname -r` string, install them at the top of the `install_debian_prerequisites` step. 
