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

    lsusb | grep 0bda

    # This output means it was properly switched to WLAN mode:
    Bus 001 Device 009: ID 0bda:b832 Realtek Semiconductor Corp. 802.11ac WLAN Adapter

    # While this output means it was NOT switched to WLAN mode:
    Bus 001 Device 003: ID 0bda:1a2b Realtek Semiconductor Corp. RTL8188GU 802.11n WLAN Adapter (Driver CDROM Mode)

If you have an older distribution that doesn't switch the adapter to WLAN mode,
you may use the following command to switch it manually:

    sudo /usr/sbin/usb_modeswitch -KQ -v 0bda -p 1a2b

If you verified that this command works, but you need to execute it manually
after every boot, then run the following commands to automate it:

    sudo -i
    echo 'echo ACTION=="add", ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="/usr/sbin/usb_modeswitch -KQ -v 0bda -p 1a2b"' >/etc/udev/rules.d/50-custom.rules
    update-initramfs -u
    reboot

## Boot delays

In rare circumstances, it's possible that the Linux boot or shutdown process
may delay for a long time while trying to access that "flash storage". To check
if that's the case, remove the adapter from the USB slot and see if the delay
is gone.

Normally, installing our driver and using an up to date distribution should
avoid this issue, but if it happens, the [following command line
parameter](https://www.draisberghof.de/usb_modeswitch/bb/viewtopic.php?f=4&p=20283#p20078)
can be [added in
grub](https://askubuntu.com/questions/19486/how-do-i-add-a-kernel-boot-parameter)
to completely ignore the flash storage mode:

    usb-storage.quirks=0bda:1a2b:i
