---
nav_exclude: true
---

# Other installation

The quickest way to troubleshoot issues is to find revealing error messages in the logs. But in some cases no such messages exist, and a broader approach is necessary. Testing with another installation would allow us the reach the following conclusions:

* If the issue does not happen in the other installation, we'll know it's a software problem with your specific installation. It might be related to the distribution, to the kernel version, to the packages involved, or to your configuration; some times the issue can be pinpointed quickly, while other times a reinstallation (while keeping /home) is faster.
* If the issue happens in the other installation too, it might be a problem with the hardware, the driver, Linux in general, the specific wifi access point... but at least we'll know that there's no point in troubleshooting your specific installation and configuration.

If you have a different operating system available, for example Windows or another Linux installation or another nearby PC, you could test there. But the best test is to create a live USB flash drive and boot with it. We recommend that you download [Ubuntu MATE 20.04](http://cdimage.ubuntu.com/ubuntu-mate/releases/20.04/release/ubuntu-mate-20.04.1-desktop-amd64.iso) which uses the well tested Network Manager software, to write it to a USB flash drive using e.g. [Rufus](https://rufus.ie/), and to boot with that.

In the live session, please follow our [installation page](https://deb.trendtechcn.com/) and see if you can connect to the access point without rebooting at all, as changes in the live session are not persistent.

Of course if this is too much effort for you, feel free to return the adapter to Amazon for a refund, as it's covered by a two year warranty. But please understand that this step is necessary when the logs do not contain enough information to pinpoint the issue.
