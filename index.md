---
nav_order: 1
---

# Installation

The following instructions should allow you to install the [AC1L](https://www.trendtechcn.com/Product.aspx?ProductId=328), [AC3L](https://www.trendtechcn.com/Product.aspx?ProductId=329) or [AC5L](https://www.trendtechcn.com/Product.aspx?ProductId=332) BrosTrend WiFi adapters in any distribution that is based on Debian 9 (Stretch) or on Ubuntu 16.04 (Xenial) or on newer versions of them.
The supported Linux kernels are from 4.0 to 5.9; this includes all [officially supported Ubuntu kernels](https://packages.ubuntu.com/search?arch=amd64&keywords=linux-image-generic).
The supported architectures are PCs (x86_32, x86_64) and Raspberry Pi 2+ (armhf for Raspberry Pi OS, amd64 for Kali Linux).
Some other architectures like BeagleBone or Nvidia Jetson are also reported to work, but we cannot officially support them.
Our repository is automatically added to your software sources, to provide automatic driver updates.

## Installation steps

1. Please note that **an Internet connection is required at the time of installation**, so as to be able to download the driver and its dependencies (dkms, linux-headers...).
That means that you might have to use a wired connection, i.e. a LAN cable.

2. Insert the WiFi adapter into a USB slot.

3. Select all the following line and right click → copy it to the clipboard. In Debian 9 Stretch, please omit the "busybox" word:

    ```shell
    sh -c 'busybox wget deb.trendtechcn.com/install -O /tmp/install && sh /tmp/install'
    ```

4. Press Alt+F2 to invoke your distribution's “Execute command” dialog, or open a terminal.
Right click → paste the previous command in order to execute it.

5. The installer requires root rights, so it will ask for your password.
It will then automatically download and install the driver for you.
When the installer finishes, the driver should be automatically loaded, but in special cases, a reboot might be necessary.

6. If the installer reported an error, please copy all the text in the terminal and paste it in a mail to [support@trend-tech.net.cn](mailto:support@trend-tech.net.cn) so that we can see what went wrong.

In case you need any other assistance in using the BrosTrend WiFi adapters, please do not hesitate to contact us by sending an email at [support@trend-tech.net.cn](mailto:support@trend-tech.net.cn).

## Deb packages

The drivers are actually packaged in .deb format: [rtl8812au-dkms.deb](rtl8812au-dkms.deb) for the AC1L and AC3L version 1 models, [rtl88x2bu-dkms.deb](rtl88x2bu-dkms.deb) for the AC1L and AC3L version 2 models and [rtl8821cu-dkms.deb](rtl8821cu-dkms.deb) for AC5L.
But please use the installer to download and install them, as it has some additional logic to detect and install the required kernel header packages.
You may examine the [installer source code](installer.sh) if you want to see the exact shell commands that it runs.
