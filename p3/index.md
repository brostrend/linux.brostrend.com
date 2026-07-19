---
nav_exclude: true
---

# P3 PCIe Ethernet adapter

The [P3 10Gbps Ethernet PCIe Network Interface
Card](https://www.brostrend.com/products/p3) works out of the box in all Linux
distributions that have [at least kernel
6.16](https://www.phoronix.com/news/Linux-6.16-Realtek-RTL8127A), which was
released on 2025-07-27, or any later kernel. This includes for example Ubuntu
25.10+, Fedora 42+, ArchLinux 2025.09.01+, Manjaro 26.0+, Kali Linux 2025.4+
and other recent distributions.

> 💡 **Tip:** To see if your distribution supports this adapter out of the box,
> run the following command; if the output is non-empty, it supports it:
>
> ```console
> # grep 10EC.*8127 /lib/modules/*/modules.alias
> /lib/modules/7.0.0-27-generic/modules.alias:alias pci:v000010ECd00008127sv*sd*bc*sc*i* r8169
> ...
> ```

The following paragraphs describe how to install a newer kernel in some older
distributions that do not have a 6.16+ kernel.

## Ubuntu 24.04 Noble Numbat

Ubuntu 24.04 Noble Numbat may have either the 6.8 kernel, or the 7.0 kernel,
depending on which installation media you used. To install the 7.0 kernel, run
the following command and reboot:

```shell
sudo apt install linux-generic-hwe-24.04
```

## Debian 13 Trixie

Debian 13 Trixie normally comes with the 6.12 kernel. To install the latest
kernel from trixie-backports, run the following command and reboot:

```shell
sudo apt install -t trixie-backports linux-image-$(dpkg --print-architecture)
```

## Source compilation

It's also possible to manually compile the driver in older distributions where
it doesn't work out of the box. Start by installing the `dkms` package, or at
least gcc, make and the kernel headers. Then go to the [Realtek driver
page](https://www.realtek.com/Download/List?cate_id=584) and [download the
driver source
code](https://www.realtek.com/Download/ToDownload?type=direct&downloadid=4636),
or just run the following commands:

```shell
wget linux.brostrend.com/p3/r8127-11.016.00.tar.bz2
tar xf r8127-11.016.00.tar.bz2
cd r8127-11.016.00
sudo make
sudo make install
sudo depmod
sudo modprobe r8127
```

## Technical information

The PCI ID and the driver in use can be shown using the following command:

```console
# lspci -nn -k | grep -A 3 Ethernet
0000:01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8127 10GbE Controller [10ec:8127] (rev 05)
        Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:0123]
        Kernel driver in use: r8169
        Kernel modules: r8169
```
