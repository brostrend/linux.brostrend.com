---
parent: Troubleshooting
---

# Source code

Our wifi adapter chipsets and drivers are developed by Realtek and are published under the [GPLv2](https://opensource.org/licenses/GPL-2.0) open source license. We package the source code in .deb format, you may download and uncompress the following files to get it:

* [rtl8812au-dkms.deb](../rtl8812au-dkms.deb) for the old AC1L and AC3L version 1 models (before 2019)
* [rtl88x2bu-dkms.deb](../rtl88x2bu-dkms.deb) for the new AC1L and AC3L version 2 models
* [rtl8821cu-dkms.deb](../rtl8821cu-dkms.deb) for AC5L
* [rtl8852bu-dkms.deb](../rtl8852bu-dkms.deb) for AX1L and AX4L
* [aic8800.deb](../aic8800.deb) for AX5L

Our installer is licensed under [GPLv3](https://opensource.org/licenses/GPL-3.0); you may [download it](../installer.sh) and view it with any text editor as it's a simple shell script.

In Debian or Ubuntu based distributions, the installer downloads and installs the appropriate .deb package and its prerequisites like [dkms](https://en.wikipedia.org/wiki/Dynamic_Kernel_Module_Support) and the kernel headers, and it also adds our repository in the apt sources to enable automatic driver updates.

In non-Debian based distributions, the installer downloads the appropriate .deb package but it doesn't install it. It uncompresses it to get the source code and register it in the [dkms](https://en.wikipedia.org/wiki/Dynamic_Kernel_Module_Support) system so that it's automatically recompiled when new kernels are installed. Unfortunately we do not provide rpm, pacman, portage or slp repositories at this point, so if you ever upgrade to a very new kernel, you might need to manually fetch our latest drivers by running our installer once more.
