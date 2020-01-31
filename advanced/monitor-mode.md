---
nav_exclude: true
---

# Monitor mode

[Monitor mode](https://en.wikipedia.org/wiki/Monitor_mode), or RFMON (Radio Frequency MONitor) mode, allows a computer with a wireless network interface controller (WNIC) to monitor all traffic received on a wireless channel.
By default, Realtek drivers ship with monitor mode disabled.
To manually enable it, first follow the [installation procedure](../../), and then run the following commands:

```shell
sudo sed 's/^\(CONFIG_WIFI_MONITOR = \).*/\1 y/' -i /usr/src/rtl88*/Makefile
cd /usr/share
sudo dpkg-reconfigure rtl88*
```

After that, reboot your computer and put the device into monitor mode with the following command:

```shell
sudo iwconfig wlan1 mode monitor
```

When updated driver packages become available in our apt repository, you will need to re-enable monitor mode using the same commands after the update is installed.
