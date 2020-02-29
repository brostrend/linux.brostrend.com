---
nav_exclude: true
---

# OSMC support

OSMC currently [doesn't support drivers that are compiled with DKMS](https://discourse.osmc.tv/t/has-anybody-tried-to-install-wireguard/73506/39), due to the following issues with their kernel headers package:

- [sys/socket.h: No such file or directory](https://discourse.osmc.tv/t/has-anybody-tried-to-install-wireguard/73506/26)
- [No /lib/modules/$(uname -r)/build symlink](https://github.com/osmc/osmc/issues/471)
- [No kernel headers metapackage](https://github.com/osmc/osmc/issues/548)

Once these are resolved in OSMC, our installer and driver will automatically work with no changes.

On the plus side, they sometimes include precompiled modules. They already have a driver for [8812au](https://github.com/osmc/rtl8812au-osmc), and a request has been made for [88x2bu](https://github.com/osmc/osmc/issues/366), so maybe users can ask the OSMC developers to include all the necessary drivers.
