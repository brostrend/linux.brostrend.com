---
nav_exclude: true
---

# P2 Ethernet adapter

The [P2 5 Gigabit Ethernet PCI-E Network Interface
Card](https://www.brostrend.com/products/p2) works out of the box in all Linux
distributions that have **at least kernel 6.9**, which was released in May
2024, or any later kernel. This includes for example Ubuntu 24.10+, Fedora 41+,
ArchLinux 2024.06.01+, Manjaro 24.0.0+, Kali Linux 2024.4+ and other recent
distributions.

> 💡 **Tip:** To see if your distribution supports this adapter out of the box,
> run the following command; if the output is non-empty, it supports it:
>
> ```console
> # grep 8126 /lib/modules/*/modules.alias
> /lib/modules/6.11.0-1008-oem/modules.alias:alias pci:v000010ECd00008126sv*sd*bc*sc*i* r8169
> ...
> ```

The following paragraphs describe how to install a newer kernel in some older
distributions that do not have a 6.9+ kernel.

## Ubuntu 24.04 Noble Numbat

Ubuntu 24.04 Noble Numbat ships with the 6.8 kernel. Currently, the easiest way
to upgrade it to 6.11 is to run the following command and reboot:

```shell
sudo apt install linux-oem-24.04b
```

## Debian 12 Bookworm

Debian 12 Bookworm normally comes with the 6.1 kernel. To install the 6.11
kernel from bookworm-backports, run the following command and reboot:

```shell
sudo apt install -t bookworm-backports linux-image-$(dpkg --print-architecture)
```

## Source compilation

It's also possible to manually compile the driver in older distributions where
it doesn't work out of the box. Start by installing the `dkms` package, or at
least gcc, make and the kernel headers. Then either go to the [Realtek driver
page](https://www.realtek.com/Download/List?cate_id=584) and [download the
driver source
code](https://www.realtek.com/Download/ToDownload?type=direct&downloadid=4445),
or just run the following commands:

```shell
wget linux.brostrend.com/p2/r8126-10.014.01.tar.bz2
tar xf r8126-10.014.01.tar.bz2
cd r8126-10.014.01
sudo make
sudo make install
sudo depmod
sudo modprobe r8126
```

## Technical information

The PCI ID and the driver in use can be shown using the following command:

```console
# lspci -nn -k | grep -A 3 Ethernet
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. Device [10ec:8126] (rev 01)
    Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:0123]
    Kernel driver in use: r8169
    Kernel modules: r8169
```
