---
nav_exclude: true
---

# P2 PCIe Ethernet adapter

The [P2 5Gbps PCIe Ethernet Network Interface
Card](https://www.brostrend.com/products/p2) works out of the box in all Linux
distributions that have **at least kernel 6.9**, which was released in May
2024, or any later kernel. This includes for example Ubuntu 24.10+, Fedora 41+,
ArchLinux 2024.06.01+, Manjaro 24.0.0+, Kali Linux 2024.4+ and other recent
distributions.

> 💡 **Tip:** To see if your distribution supports this adapter out of the box,
> run the following command; if the output is non-empty, it supports it:
>
> ```console
> # grep 10EC.*8126 /lib/modules/*/modules.alias
> /lib/modules/6.11.0-1008-oem/modules.alias:alias pci:v000010ECd00008126sv*sd*bc*sc*i* r8169
> ...
> ```

The following paragraphs describe how to install a newer kernel in some older
distributions that do not have a 6.9+ kernel.

## Ubuntu 24.04 Noble Numbat

Ubuntu 24.04 Noble Numbat may have either the 6.8 kernel, or the 7.0 kernel,
depending on which installation media you used. To install the 7.0 kernel, run
the following command and reboot:

```shell
sudo apt install linux-generic-hwe-24.04
```

## Debian 12 Bookworm

Debian 12 Bookworm normally comes with the 6.1 kernel. To install the latest
kernel from bookworm-backports, run the following command and reboot:

```shell
sudo apt install -t bookworm-backports linux-image-$(dpkg --print-architecture)
```

## DKMS package

In older distributions that don't have a 6.9+ kernel, it's possible to compile
the driver locally. The following github page provides the driver in various
forms, for example via Launchpad PPA, Debian package, DKMS package, or source
code compilation:

**<https://github.com/awesometic/realtek-r8126-dkms>**

## Technical information

The PCI ID and the driver in use can be shown using the following command:

```console
# lspci -nn -k | grep -A 3 Ethernet
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. Device [10ec:8126] (rev 01)
    Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:0123]
    Kernel driver in use: r8169
    Kernel modules: r8169
```
