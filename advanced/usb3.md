---
nav_exclude: true
---

# USB 3 mode

Some of our Wi-Fi chipsets and drivers are developed by Realtek. We prefer to
package their official drivers while modifying as few of the available
parameters as possible. For example, Realtek has chosen to disable the USB 3
port mode by default for compatibility with some older systems, which sometimes
results in lower Wi-Fi connection speeds.

> 💡 **Note:** If your access point is using the slow 2.4 GHz band, there's no
> benefit in switching to USB3 mode; it's recommended to leave it in USB2 mode.

The instructions below mention `8852bu`, which is the
[driver name](../supported-distributions.md#our-drivers) for our AX1L and AX4L
adapters. For AC1L/AC3L, replace it with `88x2bu`. For AX8L, replace it with
`8852cu`. If you see any other driver name, do not follow these instructions.

To see your current speed, insert our adapter in a USB 3 slot, open a terminal
and run `lsusb -t`. The output should be similar to this:

```shell
$ lsusb -t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
    |__ Port 6: Dev 4, If 0, Class=Vendor Specific Class, Driver=rtl8852bu, 5000M
```

If you see `Driver=rtl8852bu, 5000M` it means you're using USB 3 mode, while if
you see `480M` it's in USB 2 mode. To switch from USB2 to USB3 mode, run the
following commands:

```shell
sudo -i
echo "options 8852bu rtw_switch_usb_mode=1" >/etc/modprobe.d/local.conf
```

Then reboot your computer and run `lsusb -t` again to see if the USB speed is
now 5000M. Then connect to your access point and check if the Wi-Fi speed has
increased.

If you ever want to undo the change, run the following commands and reboot:

```shell
sudo -i
echo 2 >/sys/module/8852bu/parameters/rtw_switch_usb_mode
rm /etc/modprobe.d/local.conf
```
