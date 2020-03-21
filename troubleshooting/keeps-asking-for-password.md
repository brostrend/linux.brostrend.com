---
parent: Troubleshooting
---

# Keeps asking for password

If our driver was properly installed and nearby networks get detected, yet Network Manager keeps asking for a password, then you're probably affected by a [bug in wpasupplicant](https://bugs.launchpad.net/ubuntu/+source/wpasupplicant/+bug/1867908). We reported this to Realtek engineers and they prepared a fix, but it will need a couple of years to reach distributions as it's not in our driver code but in wpasupplicant.

To work around it, follow one of the solutions mentioned below.

## Disable MAC randomization

If you have Debian, try first the workaround mentioned in [Debian bug #879484](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=879484). That is, add the following lines at the end of /etc/NetworkManager/NetworkManager.conf, and reboot:

```shell
[device]
wifi.scan-rand-mac-address=no
```

Ubuntu already has this setting so there's no point in trying this in Ubuntu. If this doesn't work, continue with the next workaround.

## Predictable interface names

A second workaround is to revert the network adapter names from the [new style](https://wiki.debian.org/NetworkInterfaceNames) (enp2s0, wlxa1b2c3d4e5f6) to the old style (eth0, wlan0), which then do not trigger the issue. To do so, run the following commands:

```shell
sudo -i
mkdir -p /etc/default/grub.d
echo 'GRUB_CMDLINE_LINUX_DEFAULT="splash quiet net.ifnames=0"' >/etc/default/grub.d/ifnames.cfg
update-grub
reboot
```
