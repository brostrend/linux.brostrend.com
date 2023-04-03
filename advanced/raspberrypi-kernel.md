---
nav_exclude: true
---

# Raspberry Pi kernel

In March 2023, Raspberry Pi OS introduced a [breaking
change](https://forums.raspberrypi.com/viewtopic.php?t=349291). Since then, if
**Pi4**, **Pi400** or **CM4** devices are booted with the **32bit OS** image,
the **64bit kernel** gets loaded by default. This architecture mismatch between
the 32bit OS and the 64bit kernel, causes all external drivers to **fail to
compile**, including ours. Only these devices are affected, and only if they're
booted with the 32bit OS image.

It's possible to undo this change by adding `arm_64bit=0` in `/boot/config.txt`
file. You can do that with any editor, or with the following terminal commands:

    sudo -i
    sed '/arm_64bit/d' -i /boot/config.txt
    printf "[pi4]\narm_64bit=0\n" >>/boot/config.txt

Then reboot your device and re-run our installer; it should then work fine.

But note that if you have more than 4 GB RAM, it'll probably be better to
reinstall using the 64bit Raspberry Pi OS version, in order to take advantage
of all your RAM.
