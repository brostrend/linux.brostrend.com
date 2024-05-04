---
nav_exclude: true
---

# USB mode switching

Our AX1L, AX4L and AX5L adapters have a [dual mode
functionality](https://en.wikipedia.org/wiki/Virtual_CD-ROM_switching_utility).
Before installing our drivers, they act like flash storage, which contains the
Windows drivers in it. After the drivers are installed (in any OS), they switch
to normal Wi-Fi adapter mode. USB adapters that support this dual functionality
are called "multi-state", "ZeroCD" or "Virtual CD-ROM" devices.

In Linux, multi-state devices may bump into two issues:

## Adapter isn't switched to WLAN mode

Normally, the /lib/udev/rules.d/40-usb_modeswitch.rules file is responsible to
call the [usb_modeswitch command](https://manpages.debian.org/usb_modeswitch)
and switch the adapter to WLAN mode. To check if the adapter has been switched
to WLAN mode, run:

    lsusb | grep -E '(0bda|368b|a69c):(8812|b812|c811|b832|1a2b|88df|5721)'

Then consult the following table to see if the adapter is in WLAN mode or in
storage mode:

| Model | Output of lsusb |
| ----- | --------------- |
| AC1L or AC3L version 1 | Bus 003 Device 005: ID **0bda:8812** Realtek Semiconductor Corp. |
| AC1L or AC3L version 2 | Bus 003 Device 005: ID **0bda:b812** Realtek Semiconductor Corp. |
| AC5L | Bus 003 Device 005: ID **0bda:c811** Realtek Semiconductor Corp. |
| AX1L or AX4L **WLAN** mode | Bus 003 Device 005: ID **0bda:b832** Realtek Semiconductor Corp. |
| AX1L or AX4L **storage** mode | Bus 003 Device 005: ID **0bda:1a2b** Realtek Semiconductor Corp. |
| AX5L **WLAN** mode | Bus 003 Device 005: ID **368b:88df** AICSemi AIC8800DC |
| AX5L **storage** mode | Bus 003 Device 005: ID **a69c:5721** aicsemi Aic MSC |

If you have an older distribution that doesn't switch the adapter to WLAN mode,
you may use the following commands to switch it manually:

    # For AX1L and AX4L:
    sudo /usr/sbin/usb_modeswitch -KQ -v 0bda -p 1a2b
    # For AX5L:
    sudo /usr/sbin/usb_modeswitch -KQ -v a69c -p 5721

If you verified that these commands work, but you need to execute them manually
after every boot, then run the following commands to automate it:

    sudo -i
    # For AX1L and AX4L:
    echo 'echo ACTION=="add", ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="/usr/sbin/usb_modeswitch -KQ -v 0bda -p 1a2b"' >/etc/udev/rules.d/50-custom.rules
    # For AX5L:
    echo 'echo ACTION=="add", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5721", RUN+="/usr/sbin/usb_modeswitch -KQ -v a69c -p 5721"' >/etc/udev/rules.d/50-custom.rules
    # For both of them, continue with:
    update-initramfs -u
    reboot

## Boot delays

In rare circumstances, it's possible that the Linux boot or shutdown process
may delay for a long time while trying to access that "flash storage". To check
if that's the case, remove the adapter from the USB slot and see if the delay
is gone.

Normally, installing our driver and using an up to date distribution should
avoid this issue, but if it happens, the [following command line
parameter](https://www.draisberghof.de/usb_modeswitch/bb/viewtopic.php?f=4&t=3055&p=20078#p20078)
can be [added in
grub](https://askubuntu.com/questions/19486/how-do-i-add-a-kernel-boot-parameter)
to completely ignore the flash storage mode:

    usb-storage.quirks=0bda:1a2b:i usb-storage.quirks=a69c:5721:i
