---
nav_exclude: true
---

# Internal adapters

Normally it should be possible for many wifi adapters to coexist, both internal and external ones. Unfortunately some of our customers have reported that they had connectivity issues that were resolved when they disabled their internal adapter. This may be caused by a bug in the Linux kernel, in wpa_supplicant, in network-manager or elsewhere. It's probably not caused by our driver, as these problems happen with other USB adapters as well.

To temporarily disable your internal adapter and see if it makes things better, please open a terminal and follow the procedure below.

The following command shows the names of the modules (drivers) for your wifi adapters. The module for our adapters is named 8812au, 88x2bu or 8821cu. The module for Intel adapters is named "iwlwifi". For Atheros it's "ath9k", etc.

```shell
ls -d /sys/module/cfg80211/holders/*/drivers | cut -d/ -f6
# Example output:
88x2bu
iwlwifi
```

In the following commands, replace "iwlwifi" with the module that you want to blacklist:

```
sudo -i
echo "blacklist iwlwifi" > /etc/modprobe.d/local.conf
update-initramfs -u
reboot
```

After rebooting, the internal adapter should be disabled. Also, if you have more than one USB wifi adapters, remove the additional ones. Check if things work better that way.

If you ever need to remove the blacklist, use the following commands:

```shell
sudo -i
rm /etc/modprobe.d/local.conf
update-initramfs -u
reboot
```
