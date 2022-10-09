---
parent: Troubleshooting
---

# Connectivity issues

If our driver was properly installed and but you're having a hard time connecting to nearby networks, here are some possible solutions. Please try them and notify us of the result.

## 1. Extension cable

If you're connecting the wifi adapter to an extension cable or USB hub, test without it.

## 2. Different USB port

If you're testing with a front USB port, test with one at the back of the PC, or the opposite.
If you're testing with a USB3 port (blue color), test with a USB2 one (black color), or the opposite.

## 3. Signal strength

If possible, try to temporarily move your PC very close to the access point, to make sure that the problem isn't related to the signal strength or interference.

## 4. Delete wifi connections

Try to delete all existing wifi connections in case they have wrong settings, then reboot and retry to connect. If you're using Network Manager, you can open the connections dialog by running `nm-connection-editor` in a terminal.

## 5. Different access point

If possible, turn your [Android](https://support.google.com/android/answer/9059108) or [Apple](https://support.apple.com/en-us/HT204023) mobile phone into a hotspot, place it near your PC and try to connect to that, instead of your usual access point. If it connects there, then we can focus at your router settings.

## 6. Disable internal adapters

If you have an internal Wi-Fi adapter, you may [try to disable it](https://linux.brostrend.com/advanced/internal-adapters/). Some users have reported that this resolved their connectivity issues.

## 7. Disable power save mode

In some cases, Wi-Fi power save mode may result in connection instability. Run the following command in a terminal to disable it, then reboot:

```shell
sudo sed 's/^\(wifi.powersave = \).*/wifi.powersave = 2/' -i /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

If this change doesn't help, you may revert it by running the same command, while replacing the number `2` with `3`.

## 8. Enable USB3 mode

Some users have reported that [enabling USB3 mode](https://linux.brostrend.com/advanced/usb3/) resolved their connectivity issues.

## 9. Static MAC address

Open the connections dialog (`nm-connection-editor`), double click to edit the wifi connection and go to the `Wi-Fi` tab. In the `Device` box select your adapter, for example `wlx4401bb912885 (44:01:BB:91:28:85)`, and in the `Cloned MAC address` box paste the MAC address, for example `44:01:BB:91:28:85`. Save and reboot.

## 10. Disable MAC randomization

If your distribution is Debian 10 or older (**not Ubuntu**), then you might be affected by a [bug in wpasupplicant](https://bugs.launchpad.net/ubuntu/+source/wpasupplicant/+bug/1867908). Try the workaround mentioned in [Debian bug #879484](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=879484), which is to add the following lines at the end of /etc/NetworkManager/NetworkManager.conf, and reboot:

```shell
[device]
wifi.scan-rand-mac-address=no
```

## 11. Predictable interface names

In some cases it might help to revert the network adapter names from the [new style](https://wiki.debian.org/NetworkInterfaceNames) (enp2s0, wlxa1b2c3d4e5f6) to the old style (eth0, wlan0), by running the following commands:

```shell
sudo -i
mkdir -p /etc/default/grub.d
echo 'GRUB_CMDLINE_LINUX_DEFAULT="splash quiet net.ifnames=0"' >/etc/default/grub.d/ifnames.cfg
update-grub
reboot
```

If after testing you want to revert the change, run the same commands while replacing the `echo ...` line with `rm -f /etc/default/grub.d/ifnames.cfg`.

## 12. Other installation

If none of the above solutions worked, it would help to test our adapter in a [different PC and/or operating system](https://linux.brostrend.com/advanced/other-installation/).
