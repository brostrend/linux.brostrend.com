---
parent: Troubleshooting
---

# Raspbian update

Most distributions provide many kernel and kernel-headers packages. Raspbian only provides one, which currently is 5.4.51. This can create the following problem:

 * Suppose you have the older kernel=4.19.97
 * Then you perform normal OS updates (apt update)
 * So you get the new raspberrypi-kernel=5.4.51 and raspberrypi-kernel-headers=5.4.51
 * Then you install our driver

At that point our installer will fail with the following message:

> modprobe: FATAL: Module 88x2bu not found in directory /lib/modules/4.19.97

This happens because you compiled our driver for the new kernel, but you are still booted with the old kernel. Again, this is a limitation of Raspbian that only offers one kernel package, it doesn't happen in other distributions. So **a reboot is necessary to be able to load the driver**.

After rebooting, run the following command: `uname -r`

It should show 5.4.51 and our driver should now work. If it still shows the old kernel 4.19.97, this means that your OS updates were not successful. In that case, please run the following commands and send us the terminal output:

```shell
# This shows the running kernel:
uname -a

# This shows the installed kernels:
ls /lib/modules/

# This shows the installed headers:
(cd /usr/src; echo linux-headers*)

# This shows which kernels the driver was compiled for
dkms status

# These do a normal update
sudo apt update
sudo apt full-upgrade
```
