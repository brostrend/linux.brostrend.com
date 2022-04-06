---
parent: Troubleshooting
---

# OS updates

In some cases your operating system updates might not be properly installed and may cause our installer to fail. For example, if your running kernel has no matching kernel headers, you may receive an error like the following:

> modprobe: FATAL: Module 88x2bu not found in directory /lib/modules/5.15.30

To resolve this and other related issues, please fully update and reboot your system. The following command line instructions are for Ubuntu and Debian based systems; for other distributions, please use graphical tools or similar commands (`dnf upgrade`, `zypper update`, `pacman -Syu`):

```shell
sudo apt update
sudo apt full-upgrade
sudo reboot
```

The first command, `apt upgrade`, may show warnings about some of your repositories, usually you can just ignore them.

Do not be alarmed by the `apt full-upgrade` command, it just updates the existing packages, it doesn't mean "upgrade to the newer Ubuntu or other distribution version". Note that you'll need to press the Enter key for that command to continue its execution.

If `apt full-upgrade` produces no errors, please reboot your system so that the latest kernel is loaded, and then [run our installer](/) once more.

If it displays "E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)", please read our documentation about [unattended-upgrades](../unattended-upgrades/).

If it shows any other error, please stop and mail the whole terminal output to us.

If the problem persists even after successfully updating and rebooting, then please follow our [troubleshooting instructions](../).
