---
nav_exclude: true
---

# Internal adapters

Laptops, Raspberry Pis and even desktop computers may have internal wifi devices that can cause the following issues:

1. If the internal wifi is switched off, then network-manager disables all external adapters as well, [due to a bug](https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/issues/79#note_944168). The solution is to either [switch on the internal wifi](#switch-on-internal-wifi), or to [blacklist its module (driver)](#blacklist-internal-wifi-module).
2. Configuring multiple wifi devices can be tricky. See how to [select the correct device in network-manager](#select-device-in-network-manager), or [blacklist the internal wifi module](#blacklist-internal-wifi-module).

## Switch on internal wifi

To check if your wifi is switched off, run the following command in a terminal:

```shell
rfkill list

# Example output:
0: phy1: Wireless LAN
	Soft blocked: yes
	Hard blocked: no
```

If it reports "Soft blocked: yes", then you can enable wifi from the network-manager menu, or with this command: `sudo rfkill unblock 0`.

If it reports "Hard blocked: yes", then you need to enable it by pressing Fn+F5 on your laptop keyboard, or whatever other F-key has a wifi icon on top of it ([screenshot](fn-f5.jpg)). Some laptops also have a hardware "wifi on/off" switch ([screenshot](wifi-switch.jpg)). After switching it on, run `rfkill list` again and verify that wifi is no longer blocked. If you're having difficulties with this step, please send us your laptop model and some screenshots of its keys.

## Select device in network-manager

Run `nm-connection-editor` in a terminal in order to display the wifi connections dialog ([screenshot](nm-connection-editor.png)). Double click on your wifi connection and then select the "Wi-Fi" tab. In the "Device" combo box you may select which devices can use that connection:

- Your internal adapter, which is usually wlan0 or wlp2s0
- Your external adapter, which is usually wlan1 or something like wlx4401bb912885
- Or you can delete its contents and leave it empty, so that the connection can be used with any adapter

## Blacklist internal wifi module

To disable your internal adapter by blacklisting its module (driver), open a terminal and follow the procedure below. Note that for Raspberry Pi devices, [this procedure](https://raspberrypi.stackexchange.com/questions/43720/disable-wifi-wlan0-on-pi-3?answertab=active#tab-top) is recommended instead.

The following command shows the names of the modules (drivers) for your wifi adapters. The module for our adapters is named `8812au`, `88x2bu`, `8821cu`, `8852bu` or `aic8800_fdrv`. The module for Intel adapters is named `iwlwifi`, for Atheros it's `ath9k`, etc.

```shell
ls -d /sys/module/cfg80211/holders/*/drivers | cut -d/ -f6
# Example output:
88x2bu
iwlwifi
```

In the following commands, replace "iwlwifi" with the module that you want to blacklist:

```shell
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
