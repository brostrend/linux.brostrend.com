---
nav_exclude: true
---

# Tested distributions

In October 2020 we tested whether our driver is compatible with some of the most popular Debian-based distributions in distrowatch.com, and we list the results here.

| Distribution | Version | Kernel version | Headers package name | Remarks |
| - | - | - | - | - |
| [MX Linux](https://mxlinux.org) | [19.2 386](https://jztkft.dl.sourceforge.net/project/mx-linux/Final/MX-19.2_386.iso) | 4.19.0-9-686-pae | linux-headers-686-pae | OK |
| [Pop! OS](https://pop.system76.com) | [20.04 LTS](https://pop-iso.sfo2.cdn.digitaloceanspaces.com/20.04/amd64/intel/13/pop-os_20.04_amd64_intel_13.iso) | 5.4.0-7642-generic | linux-headers-generic | OK |
| [Elementary OS](https://elementary.io) | [5.1.7 Hera](https://ams3.dl.elementary.io/download/MTYwMjU2Nzg4NA==/elementaryos-5.1-stable.20200814.iso) | 5.4.0-42-generic | linux-headers-generic-hwe-18.04 | OK |
| [Zorin OS](https://zorinos.com) | [15.3 Lite](https://netix.dl.sourceforge.net/project/zorin-os/15/Zorin-OS-15.3-Lite-64-bit.iso) | 5.4.0-47-generic | linux-headers-generic-hwe-18.04 | OK |
| [KDE neon](https://neon.kde.org) | [20.04 lTS](http://www-ftp.lip6.fr/pub/X11/kde-applicationdata/neon/images/user/20201001-0946/neon-user-20201001-0946.iso) | 5.4.0-48-generic | linux-headers-generic | OK |
| [antiX Linux](https://antixlinux.com/) | [19.2.1 386](http://ftp.ntua.gr/pub/linux/mxlinux-iso/ANTIX/Final/antiX-19/antiX-19.2_386-full.iso) | 4.9.212-antix.1-486-smp | linux-headers-4.9.212-antix.1-486-smp | OK, needs sudo |
| [Puppy Linux](http://puppylinux.com/) | [FossaPup64 9.5](http://distro.ibiblio.org/puppylinux/puppy-fossa/fossapup64-9.5.iso) | 5.4.53 | [It uses PPM](http://wikka.puppylinux.com/PPM) | Unsupported |
| [Q4OS](https://q4os.org/) | [3.12 Centaurus](https://jztkft.dl.sourceforge.net/project/q4os/stable/q4os-3.12-x64.r4.iso) | 4.19.0-11-amd64 | linux-headers-amd64 | OK |
| [Endless OS](https://endlessos.com/) | [Endless 3.8.7](eos-eos3.8-amd64-amd64.201005-194955.base.iso) | 5.4.0-42-generic | [It uses flatpacks](https://support.endlessos.org/en/help-center/How-can-I-add-tools-like-GCC-on-EOS) | Unsupported |
| [Parrot OS](https://parrotlinux.org/) | [4.10 Home MATE](https://ftp.cc.uoc.gr/mirrors/linux/parrot/iso/4.10/Parrot-home-4.10_amd64.iso) | 5.7.0-2parrot2-amd46 | linux-headers-amd64 | OK |
| [PureOS](https://pureos.net) | [Hephaestus 9.0](https://downloads.pureos.net/amber/live/gnome/2020-08-06/pureos-9.0-gnome-live_20200806-amd64.hybrid.iso) | 4.19.0-9-amd64 | linux-headers-amd64 | OK |
| [Bodhi Linux](https://www.bodhilinux.com/) | [5.1](https://netix.dl.sourceforge.net/project/bodhilinux/5.1.0/bodhi-5.1.0-64.iso) | 4.15.0-88-generic | linux-headers-generic | OK |
| [Ubuntu Budgie](https://ubuntubudgie.org/) | [20.04 LTS](https://cdimage.ubuntu.com/ubuntu-budgie/releases/20.04.1/release/ubuntu-budgie-20.04.1-desktop-amd64.iso) | 5.4.0-42-generic | linux-headers-generic | OK |
| [deepin](https://www.deepin.org) | [20](http://cdimage.deepin.com/releases/20/deepin-desktop-community-1002-amd64.iso) | 5.4.50-amd64-desktop | linux-headers-deepin-amd64 | OK |
| [Linux Lite](https://www.linuxliteos.com/) | [5.0](https://dotsrc.dl.osdn.net/osdn/storage/g/l/li/linuxlite/5.0/linux-lite-5.0-64bit.iso) | 5.4.0-33-generic | linux-headers-generic | OK |
| [SparkyLinux](https://sparkylinux.org/) | [5.12](https://vorboss.dl.sourceforge.net/project/sparkylinux/lxqt/sparkylinux-5.12-x86_64-lxqt.iso) | 4.19.0-9-amd64 | linux-headers-amd64 | OK |
| [Peppermint OS](https://peppermintos.com/) | [10](https://github.com/peppermintos/Peppermint-10/releases/download/10_20191210/Peppermint-10-20191210-i386.iso) | 5.0.0-37-generic | linux-headers-generic-hwe-18.04 | OK |
| [Devuan](https://devuan.org/) | [3 (beowulf)](https://mirror.serverion.com/devuan/devuan_beowulf/desktop-live/devuan_beowulf_3.0.0_amd64_desktop-live.iso) | 4.19.0-9-amd64 | linux-headers-amd64 | [OK, needs --allow-releaseinfo-change](https://askubuntu.com/questions/989906/explicitly-accept-change-for-ppa-label) |
