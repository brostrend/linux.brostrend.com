---
nav_order: 4
---

# Supported architectures

As stated in our [Amazon product pages](https://www.amazon.com/gp/product/B07FCN6WGX/ref=ask_ql_qh_dp_hza), our drivers are only officially supported on PCs (x86_32, x86_64) and Raspberry Pi 2+ (armhf, aarch64). This is because many board manufacturers provide custom kernels for their distributions, but they lack the respective headers and build tools to be able to compile kernel modules. If you can locate and install them, then our drivers should work. You may try to [run our installer](/) before buying the adapters if you wish, to see if it successfully installs the driver or not.

To see your architecture, run:

```shell
uname -m
```

So if for example you see `mips` or `powerpc` there,  then your architecture isn't officially supported. Another reason for compilation errors is if your kernel is 64bit while your OS is 32bit, or the opposite. For example, on Rasbperry Pi OS, both [32bit (armhf)](https://www.raspberrypi.org/software/operating-systems/#raspberry-pi-os-32-bit) and [64bit (aarch64)](https://www.raspberrypi.org/forums/viewtopic.php?t=275370) installations are supported, but using the [64bit kernel8.img](https://github.com/RPi-Distro/repo/issues/157#issuecomment-581576549) on a 32bit installation is not.

> 📝 **Note** that if your architecture is unsupported and you didn't notice it when you purchased our adapter, you may return the adapter back to Amazon for a refund, as it comes with a two-year warranty.

Here is a list of some boards and distributions where our installer was successful:

| Board | Distribution | Arch | Kernel version, remarks |
|---|---|---|---|
| [Raspberry Pi 2+](https://www.raspberrypi.org/products) | [Raspberry Pi OS 10, armhf](https://downloads.raspberrypi.org/raspios_full_armhf/images/raspios_full_armhf-2021-03-25/2021-03-04-raspios-buster-armhf-full.zip) | armv7l | 5.10.17-v7+ |
| [Raspberry Pi 2+](https://www.raspberrypi.org/products) | [Ubuntu 20.04, armel](https://ubuntu.com/download/raspberry-pi) | armhf | 5.4.0-1028-raspi |
| [Raspberry Pi 4](https://www.raspberrypi.org/products) | [Kali Linux, arm64](https://images.kali.org/arm-images/kali-linux-2021.1-rpi4-nexmon.img.xz) | aarch64 | 4.19.127-Re4son-v8l+ |
| [Raspberry Pi 4](https://www.raspberrypi.org/products) | [Raspberry Pi OS 10, arm64](https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2021-04-09/2021-03-04-raspios-buster-arm64.zip) | aarch64 | 5.10.17-v8+ |
| [Raspberry Pi 4](https://www.raspberrypi.org/products) | [Ubuntu 21.04, arm64](https://ubuntu.com/download/raspberry-pi) | aarch64 | 5.11.0-1007-raspi |
| [Odroid C2](https://www.hardkernel.com/shop/odroid-c2) | [Kali Linux, arm64](https://images.kali.org/arm-images/kali-linux-2021.1-odroidc2.img.xz) | aarch64 | 5.10.0-kali7-arm64 |
| [Odroid C2](https://www.hardkernel.com/shop/odroid-c2) | [Ubuntu MATE 20.04, arm64](https://wiki.odroid.com/odroid-c2/os_images/ubuntu/v4.0) | aarch64 | 3.16.85-65 |
| [RockPro64](https://www.pine64.org/rockpro64) | [Debian, arm64](https://wiki.pine64.org/index.php?title=ROCKPro64_Software_Release#Official_Debian) | aarch64 | 5.10.0-6-arm64 |
| [RockPro64](https://www.pine64.org/rockpro64) | [Kali Linux, arm64](https://images.kali.org/arm-images/kali-linux-2021.1-pinebook-pro.img.xz) | aarch64 | 5.10.0-kali7-arm64 |

<!--
Notes:
1. Kali Linux, 32bit (armel, armv7l, 4.19.127-Re4son-v7l+) has a bug in its `kalipi-kernel-headers 4.19.127-20210223` package, and needs this command:


```shell
sudo ln -s /usr/src/linux-headers-* /lib/modules/$(uname -r)/build
```

2. Ubuntu names: linux-image-raspi, linux-headers-raspi, preinstalled
-->
