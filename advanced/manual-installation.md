---
nav_exclude: true
---

# Manual installation

As mentioned in our product page on Amazon and in our [supported distributions page](https://deb.trendtechcn.com/supported-distributions), we can only support Debian based distributions at this time. Nevertheless, more advanced users might be able to install the driver by manually compiling from source, without using a package manager. The following instructions were successfully tested in some non-Debian based distributions, namely openSUSE Leap 15.1, Fedora 30, CentOS 8, Arch Linux 2020.03.01 and Manjaro 19.0.2.

> 📝 **Note** that we accept remarks/contributions about this page, but we're unable to provide support for it; if the instructions weren't successful for you, please return our adapter for a refund.

# Prerequisites

The following packages should be installed before compiling the driver:
 - bc: the GNU bc calculator is needed by the Makefile
 - kernel headers: they are needed for compiling kernel modules.
   They should provide this directory: `ls /lib/modules/$(uname -r)/build`.
 - gcc, make etc: needed to compile the driver
 - dkms: allows the driver to be automatically recompiled on kernel updates

The command to install these packages depends on your distribution. Here are some examples:

```shell
# openSUSE:
sudo zypper install bc kernel-devel dkms
# Fedora:
sudo dnf install bc kernel-devel dkms
# Arch/Manjaro; in Manjaro, select the current kernel, not the old linux316:
sudo pacman -Sy bc linux-headers dkms
```

# Getting the source and compiling

From our [driver page](https://deb.trendtechcn.com/#deb-packages), retrieve the .deb package that matches your adapter and uncompress it to get the source. Here's an example for AC1L V2 and AC3L V2:

```shell
# Create a temporary folder
cd $(mktemp -d)
# Get the .deb
wget https://deb.trendtechcn.com/rtl88x2bu-dkms.deb
# Uncompress the .deb
ar x rtl88x2bu-dkms.deb
tar xf data.tar.xz .
# Move the source code to /usr/src/rtl88*
sudo mv usr/src/rtl88* /usr/src/
# Go to the driver source code directory
cd /usr/src/rtl88*
```

For distributions that **do not have dkms**, the following commands need to be run manually after each kernel update:

```shell
make
sudo make install
```

If you did install dkms, run the following instructions instead:

```
# We're in the /usr/src/rtl88* directory
sudo dkms add .
# See that dkms lists the driver name and version
dkms status
# Use the correct name/version in this command
sudo dkms install rtl88x2bu/5.6.1.5.35370.20191021
```

# Additional instructions

Some distributions need extra instructions; we list them here.

## openSUSE

openSUSE backports kernel patches which confuse the Makefile. If compilation fails, try the following sed command, then recompile:

```shell
# After all the installation instructions up to `cd /usr/src/rtl88*`
sudo sed 's/4, 19, 0/4, 12, 0/' -i os_dep/linux/os_intfs.c
```

## CentOS

CentOS needs an extra repository for dkms installation. Additionally, if compilation fails, try the following sed commands, then recompile:

```shell
wget dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo rpm -ivh epel-release-latest-8.noarch.rpm
# After all the installation instructions up to `cd /usr/src/rtl88*`
sudo sed 's/4, 19, 0/4, 12, 0/' -i os_dep/linux/os_intfs.c
sudo sed 's/5, 0, 0/4, 12, 0/' -i os_dep/linux/rtw_android.c
```
