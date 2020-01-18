---
parent: Troubleshooting
---

# Mismatched headers

In some cases it's possible to have multiple kernels installed, for example 4.19.**57** and 4.19.**75**, but to only have the kernel headers for one of those versions. This may happen for example if you update your Raspbian operating system to a new kernel, and then try to install our driver before rebooting. In this case, driver installation will fail with a message like the following:

> modprobe: FATAL: Module 88x2bu not found in directory /lib/modules/4.19.57

This happens because the running kernel is the old one, yet only the headers for the new one exist.

The solution is to reboot to the kernel for which the headers are installed. Removing the older kernel packages might also help.

To see which kernels and headers are installed, the following commands may help:

```shell
# This shows the running kernel:
uname -a

# This shows the installed kernels:
ls /lib/modules/

# This shows the installed headers:
(cd /usr/src; echo linux-headers*)

# This shows which kernels the driver was compiled for
dkms status
```
