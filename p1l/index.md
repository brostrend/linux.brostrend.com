---
nav_exclude: true
---

# P1L Ethernet adapter

The P1L 2.5 Gigabit Ethernet PCI-E Network Interface Card works out of the box
in all Linux distributions that have **at least kernel 5.9**, which was
released on Oct 2020, or any later kernel. This includes for example Ubuntu
20.04+, Debian 11+, Fedora 33+ and all recent distributions.

Additionally, it works out of the box in the following distributions, even
though they have kernels older than 5.9; that's because these distributions
have backported the necessary r8169 driver:

- CentOS Linux 8 with kernel 4.18.0-348.7.1.el8_5.x86_64
- CentOS Stream 8 with kernel 4.18.0-483.el8.x86_64
- OpenSUSE Leap 15.3 with kernel 5.3.18-150300.59.106
- RHEL 8.3 with kernel 4.18.0-240.22.1.el8_3.x86_64

The following paragraphs describe how to install a newer kernel in some older
distributions that do not have a 5.9+ kernel.

## Ubuntu Focal 20.04

Ubuntu Focal 20.04 may have either the 5.4 kernel, or the 5.15 kernel,
depending on which installation media you used. To install the 5.15 kernel, run
the following command and reboot:

    sudo apt install linux-generic-hwe-20.04

## Debian Buster 10

Debian Buster normally comes with the 4.19 kernel. To install the 5.10 kernel, run the following command and reboot:

    sudo apt install linux-image-5.10-$(dpkg --print-architecture)

## Source compilation

It's also possible to manually compile the driver in older distributions where
it doesn't work out of the box. Either go to the [Realtek driver
page](https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software)
and [download the driver source
code](https://www.realtek.com/en/directly-download?downloadid=8a2ffcae711e2dfb96e6f33843bbdc08),
or just run the following commands:

    wget linux.brosrend.com/t1l/r8125-9.011.00.tar.bz2
    tar xf r8125-9.011.00.tar.bz2
    cd r8125-9.011.00
    sudo make
    sudo make install
    sudo depmod
    sudo modprobe r8125

## Technical information

The PCI ID and the driver in use can be shown using the following command:

    # lspci -nn -k | grep -A 3 Ethernet
    05:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller [10ec:8125] (rev 04)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller [10ec:8125]
        Kernel driver in use: r8169
        Kernel modules: r8169

To see if your distribution supports this adapter out of the box, run the
following command; if the output is non-empty, it supports it:

    # grep 8125 /lib/modules/*/modules.alias
    /lib/modules/5.15.0-69-generic/modules.alias:alias pci:v000010ECd00008125sv*sd*bc*sc*i* r8169
    /lib/modules/5.19.0-38-generic/modules.alias:alias pci:v000010ECd00008125sv*sd*bc*sc*i* r8169
    ...
