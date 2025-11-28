---
nav_order: 2
---

# Supported distributions

Recent Linux kernels include their own drivers for most of our adapters, so
they work **out of the box** in the distributions that have them. We suggest
that you use the in-kernel drivers and that you only run our installer if you
encounter any issues.

## In-kernel drivers

The in-kernel drivers (modules) and the adapters they support are listed in the
following table:

| Driver                                                          | Adapter                         | Since Linux kernel version  |
| --------------------------------------------------------------- | ------------------------------- | --------------------------- |
| [rtw88_8812au](https://www.kernelconfig.io/config_rtw88_8812au) | Old AC1Lv1, AC3Lv1, before 2019 | 6.13 (2025-01-19)           |
| [rtw88_8822bu](https://www.kernelconfig.io/config_rtw88_8822bu) | New AC1Lv2, AC3Lv2              | 6.2 (2023-02-19)            |
| [rtw88_8821cu](https://www.kernelconfig.io/config_rtw88_8821cu) | AC5L                            | 6.2 (2023-02-19)            |
| [rtw89_8852bu](https://www.kernelconfig.io/config_rtw89_8852bu) | AX1L, AX4L                      | 6.17 (2025-09-28)           |
| [rtw89_8852cu](https://www.kernelconfig.io/config_rtw89_8852cu) | AX8L                            | 6.18 (end of 2025)          |
| [mt7921au](https://www.kernelconfig.io/config_mt7921u)          | AX9L                            | 5.18 (2022-05-22)           |
| [rtw89_8851bu](https://www.kernelconfig.io/config_rtw89_8851bu) | WB1L                            | 6.17 (2025-09-28)           |
| [r8169](https://www.kernelconfig.io/config_r8169)               | P1L                             | 5.9 (2020-10-11)            |
| -                                                               | AX5L, AX7L, AX7PL               | **No in-kernel driver yet** |

To see your kernel version, open a terminal and run the following command:

```shell
uname -r
```

Note that on Debian, you might have to install the related firmware packages
and reboot for the drivers to work:

```shell
sudo apt install --yes firmware-realtek firmware-mediatek
```

## Our drivers

Hundreds of Linux distributions exist so it's impossible to list or support all
of them. Our driver release process is as follows:

> 💡 Every time a new official Ubuntu, Debian or Raspberry Pi OS version is
> released, we make sure that we have already uploaded a compatible driver in
> our repository.

**This means that we support all official Ubuntu, Debian and Raspberry Pi OS
versions, including all their derivatives as long as they use the same kernel
and are not [immutable](https://itsfoss.com/immutable-linux-distros).**

But this also means that we cannot support distributions that frequently have a
newer kernel than Ubuntu, such as ArchLinux or PoP!_OS, or distributions that
have a modified kernel, such as Kali Linux or Armbian. For these distributions,
consider using using one of our adapters that have [in-kernel
drivers](#in-kernel-drivers).

### A non-exhaustive list of distributions that our drivers support is

- [All official Ubuntu flavors](https://wiki.ubuntu.com/UbuntuFlavors) and
  their derivatives with the same kernel, such as [Bodhi
  Linux](https://www.bodhilinux.com), [Edubuntu](https://www.edubuntu.org),
  [Elementary OS](https://elementary.io), [Feren
  OS](https://ferenos.weebly.com), [Freespire](https://www.freespire.net), [KDE
  neon](https://neon.kde.org), [Kubuntu](https://kubuntu.org), [Linux
  Lite](https://www.linuxliteos.com), [Linux Mint](https://linuxmint.com),
  [LinuxFX](https://linuxfx.org), [LXLE](https://www.lxle.net),
  [Lubuntu](https://lubuntu.me), [Netrunner](https://www.netrunner.com),
  [Nitrux](https://nxos.org), [Peppermint OS](https://peppermintos.com),
  [Trisquel](https://trisquel.info), [Ubuntu Budgie](https://ubuntubudgie.org),
  [Ubuntu Cinnamon](https://ubuntucinnamon.org), [Ubuntu
  Kylin](https://www.ubuntukylin.com), [Ubuntu MATE](https://ubuntu-mate.org),
  [Ubuntu Studio](https://ubuntustudio.org), [Ubuntu
  Unity](https://ubuntuunity.org), [Voyager](https://voyagerlive.org),
  [Xubuntu](https://xubuntu.org), [Zorin OS](https://zorinos.com).
- [All official Debian blends](https://www.debian.org/blends) and their
  derivatives with the same kernel, such as [Devuan](https://devuan.org), [MX
  Linux](https://mxlinux.org), [Parrot OS](https://parrotsec.org),
  [PureOS](https://pureos.net), [Q4OS](https://q4os.org),
  [SparkyLinux](https://sparkylinux.org), [Ultimate
  Edition](http://ultimateedition.info).
- [Raspberry Pi OS](https://www.raspberrypi.org) and its derivatives with the
  same kernel.

### A non-exhaustive list of distributions that our drivers do NOT support is

[ALT Linux](http://en.altlinux.org), [antiX Linux](https://antixlinux.com),
[Arch Linux](https://archlinux.org), [Arco Linux](https://arcolinux.com),
[Armbian](https://www.armbian.com), [Artix
Linux](https://artixlinux.org/download.php), [Bluestar
Linux](https://sourceforge.net/projects/bluestarlinux), [CentOS
Linux](https://www.centos.org), [CentOS Stream](https://www.centos.org), [Clear
Linux](https://clearlinux.org), [deepin](https://www.deepin.org),
[EndeavourOS](https://endeavouros.com), [Endless OS](https://endlessos.com),
[Fedora Workstation](https://getfedora.org), [Garuda
Linux](https://garudalinux.org), [Gecko
Linux](https://sourceforge.net/projects/geckolinux), [Gentoo
Linux](https://www.gentoo.org), [Guix](https://guix.gnu.org), [KaOS
Linux](https://kaosx.us), [Kali Linux](https://www.kali.org),
[Kodachi](https://www.digi77.com/linux-kodachi),
[LibreELEC](https://libreelec.tv), [Linux CNC](https://linuxcnc.org),
[Mageia](https://www.mageia.org), [Manjaro Linux](https://manjaro.org), [Oracle
Linux](https://www.oracle.com/linux),
[OpenMandriva](https://www.openmandriva.org), [openSUSE
Leap](https://www.opensuse.org), [openSUSE
Tumbleweed](https://www.opensuse.org), [PCLinuxOS](https://www.pclinuxos.com),
[Pop! OS](https://pop.system76.com), [Puppy Linux](http://puppylinux.com),
[Reborn OS](https://rebornos.org), [Red Hat Enterprise
Linux](https://www.redhat.com), [Scientific
Linux](https://scientificlinux.org), [Slackware](https://www.slackware.com),
[Solus](https://getsol.us), [Tails](https://tails.boum.org), [Tiny Core
Linux](http://www.tinycorelinux.net), [Ubuntu Core](https://ubuntu.com/core),
[Void Linux](https://voidlinux.org), [Windows Subsystem for
Linux](https://docs.microsoft.com/en-us/windows/wsl/install)

For the distributions that our drivers do not support, consider using one of
our adapters that have [in-kernel drivers](#in-kernel-drivers).

> 📝 **Note** that if your distribution or architecture is unsupported and you
> didn't notice it when you purchased our adapter, you may return the adapter
> back to Amazon for a refund, as it comes with two years of warranty.
