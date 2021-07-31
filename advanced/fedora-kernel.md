---
nav_exclude: true
---

# Fedora kernel

Our wifi adapter chipsets and drivers are developed by Realtek. When new kernels are released, we rely on them to send us updated, compatible drivers. And while Realtek responds relatively fast, sometimes Fedora is faster and adopts new kernels before we have drivers for them. While we do state the supported kernel versions in our Amazon product pages, this may inconvenience our Fedora users. A workaround is to use a previous kernel version, by following **one** of the two methods mentioned below.

## Install the previous supported kernel

For example, on May 2021 Fedora switched to kernel 5.12 while our driver only supported up to 5.11. The following command lists the available kernel versions:

```shell
dnf search --showduplicates kernel-devel
...
kernel-devel-5.11.12-300.fc34.x86_64
kernel-devel-5.12.6-300.fc34.x86_64
```

Since a 5.11 kernel is available, let's install it along with its headers:

```shell
sudo dnf install kernel-5.11.12-300.fc34.x86_64 kernel-devel-5.11.12-300.fc34.x86_64
```

Now reboot, select that kernel in the grub boot manager menu, and [re-run our installer](../../).

## Install any previous kernel

If no compatible kernel can be located with `dnf search --showduplicates kernel-devel`, it's possible to install any previous kernel with the following procedure.

```shell
mkdir /tmp/kernel
cd /tmp/kernel
sudo dnf install koji
koji download-build --arch=x86_64 kernel-5.11.17-300.fc34-x86_64
rm *debug* *internal*
sudo dnf install ./kernel*.rpm
```

Now reboot, select that kernel in the grub boot manager menu, and [re-run our installer](../../).
