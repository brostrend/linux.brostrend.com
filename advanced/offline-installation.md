---
nav_exclude: true
---

# Offline installation

Drivers need a lot of dependencies in order to be compiled under Linux, for example the Linux kernel headers and the Dynamic Kernel Module Support (DKMS) package. Thousands of different versions of the kernel headers exist in distributions, and new versions are produced very often. See for example [some of the Ubuntu kernels](https://launchpad.net/ubuntu/+source/linux/+publishinghistory).

For those reasons, it's impossible for us to provide a "driver DVD" with all the necessary dependencies; it would need to be lots of Terabytes in size, and it would have to be updated weekly.

This is why we require an Internet connection at the time of installation; our install runs `sudo apt update` to get the list of the latest kernels available for your distribution, and then installs them, before installing our .deb package.

> 💡 **Tip:** If you do not have wired Ethernet, the easiest way to get Internet connectivity is with [mobile phone WiFi-to-USB
tethering](https://www.makeuseof.com/tag/how-to-tether-your-smartphone-in-linux/), which connects your PC to your Wi-Fi access point using your phone like a USB WLAN adapter.

Very advanced users and in limited cases might be able to perform an offline installation, by following the instructions below.

First, run the following command in the target computer, to get the list of dependencies:

```shell
sudo apt install --print-uris dkms bc linux-libc-dev libc6-dev
```

This will give you a list of lines like the one below:

```shell
'http://us.archive.ubuntu.com/ubuntu/pool/main/d/dkms/dkms_2.8.1-4ubuntu1_all.deb' dkms_2.8.1-4ubuntu1_all.deb 66900 MD5Sum:522a52721894fda00432114af35dad38
```

Now you're supposed to go to another computer, insert a USB stick, create a /media/user/stick/driver folder, and download all the packages there:

```shell
mkdir /media/user/stick/driver
cd /media/user/stick/driver
wget 'http://us.archive.ubuntu.com/ubuntu/pool/main/d/dkms/dkms_2.8.1-4ubuntu1_all.deb'
...
wget https://linux.brostrend.com/rtl8812au-dkms.deb
```

Note the last command there. You're supposed to manually replace the
`rtl8812au-dkms.deb` package name with the appropriate one for your adapter,
from the following list (while our installer autodetects it):

* [rtl8812au-dkms.deb](../rtl8812au-dkms.deb) for the old AC1L and AC3L version 1 models (before 2019)
* [rtl88x2bu-dkms.deb](../rtl88x2bu-dkms.deb) for the new AC1L and AC3L version 2 models
* [rtl8821cu-dkms.deb](../rtl8821cu-dkms.deb) for AC5L
* [rtl8852bu-dkms.deb](../rtl8852bu-dkms.deb) for AX1L and AX4L
* [aic8800-dkms.deb](../aic8800-dkms.deb) for AX5L

Also note that if your computer was offline for weeks, it's possible that newer kernel or dkms packages were published, and the old ones were deleted, and the URLs above are no longer valid. In this case you'd need to connect the target computer online and run `apt update` to get an updated list of URLs.

Finally, if you manage to gather all the dependencies, go to the target computer and run the following:

```shell
cd /media/user/stick/driver
sudo apt install ./*.deb
```
