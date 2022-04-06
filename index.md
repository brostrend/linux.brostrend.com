---
nav_order: 1
---

# Installation

The following instructions install the appropriate drivers for the [AC1L](https://www.trendtechcn.com/Product.aspx?ProductId=328), [AC3L](https://www.trendtechcn.com/Product.aspx?ProductId=329) and [AC5L](https://www.trendtechcn.com/Product.aspx?ProductId=332) BrosTrend WiFi adapters in any of the [supported distributions](supported-distributions). All the drivers and the installer are open source (GPL); you may get the code from [here](troubleshooting/source-code).

> 💡 **Tip:** It is highly recommended to [update and reboot your system](troubleshooting/os-updates) before running our installer, to avoid some common issues like mismatched kernel headers or old http certificates.

## Installation steps

1. Please note that **an Internet connection is required at the time of installation**, so as to be able to download the driver and its dependencies (dkms, linux-headers...).
That means that you might have to use a wired connection (LAN cable) or [mobile phone wifi-to-usb tethering](https://www.makeuseof.com/tag/how-to-tether-your-smartphone-in-linux/).

2. Insert the WiFi adapter into a USB slot.

3. Select all the following line and right click → copy it to the clipboard:

    ```shell
    sh -c 'wget deb.trendtechcn.com/install -O /tmp/install && sh /tmp/install'
    ```

4. Press Alt+F2 to invoke your distribution's “Execute command” dialog, or open a terminal.
Right click → paste the previous command in order to execute it. If it fails with "wget: command not found", please try one of the [alternative installation commands](troubleshooting/alternative-installation-commands).

5. The installer requires root rights, so it will ask for your password.
It will then automatically download, install and load the correct driver for your adapter. In some cases a reboot might be necessary.

6. If the installer reports an error, please copy all the text in the terminal and paste it in a mail to [support@trend-tech.net.cn](mailto:support@trend-tech.net.cn) so that we can see what went wrong. Please also attach the auto-generated log file, /tmp/troubleshooting.txt.

If your distribution is based on Debian, our apt repository will be automatically added to your software sources, to provide automatic driver updates. For non-Debian distributions please re-run our installer whenever you need to update to our latest drivers.

In case you need any assistance in using the BrosTrend WiFi adapters, please do not hesitate to contact us by sending an email at [support@trend-tech.net.cn](mailto:support@trend-tech.net.cn).
