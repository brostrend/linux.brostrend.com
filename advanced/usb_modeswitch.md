---
nav_exclude: true
---

# USB mode switching

> 💡 **Summary:** If a PC is being (re)booted, and an AX1L or AX4L adapter is
> inserted in a USB slot, and the driver isn't installed yet, then it might
> take an extremely long time to boot. To avoid that, just remove the adapter
> from the USB slot.

Our AX1L and AX4L adapters have a dual mode functionality. Before installing
our drivers, they act like a flash storage, which contains the Windows drivers
in it. After the drivers are installed (in any OS), they switch to normal Wi-Fi
adapter mode.

USB devices that support this dual functionality are called "multi-state" or
"ZeroCD", and the mode of operation can be toggled under Linux with the
[usb_modeswitch command](https://manpages.debian.org/usb_modeswitch).

Unfortunately, in certain cases the Linux boot process might hang for a long
time, while trying to detect that "flash storage". This doesn't happen in
distributions that ship an updated /lib/udev/rules.d/40-usb_modeswitch.rules
file. But in any case, after our driver gets installed the device is switched
to Wi-Fi mode and the problem doesn't happen anymore. So if it happens for you,
just unplug the device, and after the PC boots insert it in a USB slot and
install our driver.

For more information, see the [usb_modeswitch man
page](https://manpages.debian.org/usb_modeswitch) or the [Wikipedia Virtual
CD-ROM page](https://en.wikipedia.org/wiki/Virtual_CD-ROM_switching_utility).
