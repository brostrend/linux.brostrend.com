---
nav_exclude: true
---

# Uninstall

To uninstall our drivers on **Debian derivatives**, run this command:

```shell
sudo apt purge aic8800-dkms rtl8812au-dkms rtl88x2bu-dkms rtl8821cu-dkms rtl8852bu-dkms rtl8852cu-dkms
```

It's OK to list all our drivers in the command even if you only have one of
them installed. Then reboot your PC.

To uninstall our drivers on **non-Debian distributions**, run the following
commands:

```shell
sudo -i
# This will show a list of installed drivers and versions
dkms status
# For each one of our drivers, run commands like the ones below
# Where needed, replace the driver name and version
/usr/src/rtl8852bu-1.19.21/driverctl postrm
dkms remove -m rtl8852bu -v 1.19.21 --all
rm -rf /usr/src/rtl8852bu-1.19.21
```
