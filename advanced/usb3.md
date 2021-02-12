---
nav_exclude: true
---

# USB 3 mode

Our wifi adapter chipsets and drivers are developed by Realtek. We prefer to package their official drivers while modifying as few of the available parameters as possible. For example, Realtek has chosen to disable USB 3 port mode by default for compatibility with some older systems, which sometimes results in lower wifi connection speeds.

The instructions below mention `88x2bu`, which is the driver name for our AC1L and AC3L adapters. For the AC5L adapter, please replace `88x2bu` with `8821cu` wherever you see it below.

To see your current speed, insert our adapter in a USB 3 slot, open a terminal and run `lsusb -t`. The output should be similar to this:

```shell
$ lsusb -t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
    |__ Port 6: Dev 4, If 0, Class=Vendor Specific Class, Driver=rtl88x2bu, 5000M
```

If you see `Driver=rtl88x2bu, 5000M` it means you're using USB 3 mode, while if you see `480M` it's in USB 2 mode. To switch from USB2 to USB3 mode, run the following commands:

```shell
sudo -i
echo "options 88x2bu rtw_switch_usb_mode=1" > /etc/modprobe.d/local.conf
```

Then reboot your computer and run `lsusb -t` again to see if the USB speed is now 5000M. Then reconnect to your wifi and check if the wifi speed has also increased.

If you ever want to undo the change, run the following command and reboot:

```shell
sudo -i
echo 2 > /sys/module/88x2bu/parameters/rtw_switch_usb_mode
rm /etc/modprobe.d/local.conf
```
