---
nav_order: 2
---

# Supported distributions

> 📝 **Note** the following table lists the distributions that our installation script supports. Unfortunately, there's an additional restriction; the driver compilation won't succeed when the Linux kernel version is very new; please read our [kernel-version documentation](../troubleshooting/kernel-version/) about this issue.

We try to support as many Linux distributions as possible. But there are so many that it's impossible to test all of them. Also, some do not provide the required kernel headers and build tools, or target exotic hardware that we don't have access to.

The following table lists some of the the distributions where we have successfully tested our installation process. The meaning of the remarks column is:

* apt: our driver repository is added to your sources and you won't have to re-run our installer unless you reinstall your OS from scratch
* apt-rpm, dnf, pacman, ppm, swupd, yum, xbps, zypper: no driver repository; you'll have to re-run our installer manually after major kernel version updates (e.g. from 5.8 to 5.11)
* eopkg, pkgtool: no [dkms](https://en.wikipedia.org/wiki/Dynamic_Kernel_Module_Support); you'll have to re-run our installer manually after even minor kernel version updates (e.g. from 5.10.1 to 5.10.2)

| Distribution | Version | Headers package | Remarks |
|---|---|---|---|
| [All official Ubuntu flavors](https://wiki.ubuntu.com/UbuntuFlavors) | [16.04 - 21.04](https://ubuntu.com/download) | linux-headers-* | apt |
| [All official Debian blends](https://www.debian.org/blends) | [8 - 11](https://www.debian.org/distrib) | linux-headers-* | apt |
| [ALT Linux](http://en.altlinux.org) | [9.1](https://mirror.yandex.ru/altlinux/p9/images/server/x86_64/alt-server-9.1-x86_64.iso) | kernel-header-modules-std-def | apt-rpm |
| [antiX Linux](https://antixlinux.com) | [19.3 386](http://ftp.ntua.gr/pub/linux/mxlinux-iso/ANTIX/Final/antiX-19/antiX-19.3_386-full.iso) | linux-headers-4.9.235-antix.1-486-smp | apt, see note 1 |
| [Arch Linux](https://archlinux.org) | [rolling](https://archlinux.org/download) | linux-headers | pacman |
| [Arco Linux](https://arcolinux.com) | [rolling](https://kumisystems.dl.sourceforge.net/project/arcolinux/ArcoLinux/arcolinux-v21.03.11-x86_64.iso) | linux-headers | pacman |
| [Artix Linux](https://artixlinux.org/download.php) | [rolling](http://ftp.ntua.gr/pub/linux/artix-iso/artix-cinnamon-openrc-20210101-x86_64.iso) | linux-headers | pacman |
| [Bluestar Linux](https://sourceforge.net/projects/bluestarlinux) | [rolling](https://kumisystems.dl.sourceforge.net/project/bluestarlinux/distro/bluestar-linux-5.11.15-2021.04.19-x86_64.iso) | linux-headers | pacman |
| [Bodhi Linux](https://www.bodhilinux.com) | [5.1](https://netix.dl.sourceforge.net/project/bodhilinux/5.1.0/bodhi-5.1.0-64.iso) | linux-headers-generic | apt |
| [Clear Linux](https://clearlinux.org) | [2.7.2](https://cdn.download.clearlinux.org/releases/34500/clear/clear-34500-live-desktop.iso) | kernel-lts2019-dkms | swupd, needs reboot |
| [deepin](https://www.deepin.org) | [20.2](http://cdimage.deepin.com/releases/20.2/deepin-desktop-community-20.2-amd64.iso) | linux-headers-deepin-amd64 | apt |
| [Devuan](https://devuan.org) | [3 (beowulf)](http://merlin.fit.vutbr.cz/mirrors/devuan-cd/devuan_beowulf/desktop-live/devuan_beowulf_3.1.1_amd64_desktop-live.iso) | linux-headers-amd64 | apt |
| [Elementary OS](https://elementary.io) | [5.1.7 Hera](https://ams3.dl.elementary.io/download/MTYwMjU2Nzg4NA==/elementaryos-5.1-stable.20200814.iso) | linux-headers-generic-hwe-18.04 | apt |
| [EndeavourOS](https://endeavouros.com) | [rolling](https://deac-riga.dl.sourceforge.net/project/garuda-linux/xfce/210406/garuda-xfce-linux-lts-210406.iso) | linux-headers | pacman |
| [Enso OS](https://www.enso-os.site) | [0.4](https://deac-riga.dl.sourceforge.net/project/enso-os/Enso-0.4/Enso-0.4.iso) | linux-headers-generic | apt |
| [Fedora Workstation](https://getfedora.org) | [33](https://download.fedoraproject.org/pub/fedora/linux/releases/33/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-33-1.2.iso) | kernel-devel | dnf |
| [Feren OS](https://ferenos.weebly.com) | [pseudo-rolling](https://altushost-swe.dl.sourceforge.net/project/ferenoslinux/Feren-OS-standarddt.iso) | linux-headers-generic | apt |
| [Freespire](https://www.freespire.net) | [7.0](https://distro.ibiblio.org/blacklab/freespire/7/freespire-7.iso) | linux-headers-generic | apt |
| [Garuda Linux](https://garudalinux.org) | [rolling](https://saimei.ftp.acc.umu.se/mirror/endeavouros/iso/endeavouros-2021.04.17-x86_64.iso) | linux-headers | pacman |
| [Gecko Linux](https://sourceforge.net/projects/geckolinux) | [15.2](https://deac-fra.dl.sourceforge.net/project/geckolinux/Static/152.210223/GeckoLinux_STATIC_XFCE.x86_64-152.210223.0.iso) | kernel-devel | zypper |
| [Gentoo Linux](https://www.gentoo.org) | [rolling](https://deac-riga.dl.sourceforge.net/project/osboxes/v/vb/22-Gn-t/201910/CLI/Gnt2019.10-CLI-VB-64bit.7z) | linux-headers | emerge deps manually |
| [KaOS Linux](https://kaosx.us) | [rolling](https://deac-fra.dl.sourceforge.net/project/kaosx/ISO/KaOS-2021.03-x86_64.iso) | linux-headers | pacman, no dkms |
| [Kali Linux](https://www.kali.org) | [2020.04](http://cdimage.kali.org/kali-2020.4/kali-linux-2020.4-live-amd64.iso) | linux-headers-amd64 | apt |
| [KDE neon](https://neon.kde.org) | [20.04](http://www-ftp.lip6.fr/pub/X11/kde-applicationdata/neon/images/user/20201001-0946/neon-user-20201001-0946.iso) | linux-headers-generic | apt |
| [Kodachi](https://www.digi77.com/linux-kodachi) | [8.4](https://deac-ams.dl.sourceforge.net/project/linuxkodachi/kodachi-8.4-64.iso) | linux-headers-generic | apt |
| [Linux CNC](https://linuxcnc.org) | [2.8.0](http://www.linuxcnc.org/iso/linuxcnc-2.8.0-buster.iso) | linux-headers-rt-amd64 | apt |
| [Linux Lite](https://www.linuxliteos.com) | [5.0](https://dotsrc.dl.osdn.net/osdn/storage/g/l/li/linuxlite/5.0/linux-lite-5.0-64bit.iso) | linux-headers-generic | apt |
| [Linux Mint](https://www.linuxmint.com) | [19 - 20.1](https://www.linuxmint.com/download_all.php) | linux-headers-generic | apt |
| [LinuxFX](https://www.linuxfx.org) | [10.8](https://deac-riga.dl.sourceforge.net/project/linuxfxdevil/linuxfx-10.8.1.106-plasma-w10.iso) | linux-headers-generic | apt |
| [LXLE](https://www.linuxfx.org) | [18.04](https://kumisystems.dl.sourceforge.net/project/lxle/Final/OS/18.04.3-32/lxle-18043-32.iso) | linux-headers-generic | apt |
| [Mageia](https://www.mageia.org) | [8](https://mirror.tuxinator.org/mageia/iso/8/Mageia-8-Live-Xfce-i586/Mageia-8-Live-Xfce-i586.iso) | kernel-devel | dnf |
| [Manjaro Linux](https://manjaro.org) | [rolling](https://download.manjaro.org/xfce/21.0.1/manjaro-xfce-21.0.1-210410-linux510.iso) | linux-headers | pacman, see note 2 |
| [MX Linux](https://mxlinux.org) | [19.2 386](https://jztkft.dl.sourceforge.net/project/mx-linux/Final/MX-19.2_386.iso) | linux-headers-686-pae | apt |
| [Netrunner](https://www.netrunner.com) | [21.01](https://kumisystems.dl.sourceforge.net/project/netrunneros/netrunner-desktop/netrunner-2101/netrunner-desktop-2101-64bit.iso) | linux-headers-generic | apt |
| [Nitrux](https://nxos.org) | [1.3.9](https://jztkft.dl.sourceforge.net/project/nitruxos/Release/nitrux-minimal-release-amd64_2021.03.30.iso) | linux-headers-generic | apt |
| [Oracle Linux](https://www.oracle.com/linux) | [8.3](https://yum.oracle.com/ISOS/OracleLinux/OL8/u3/x86_64/OracleLinux-R8-U3-x86_64-dvd.iso) | kernel-devel | dnf, use -uek kernel |
| [OpenMandriva](https://www.openmandriva.org) | [4.2 Argon](https://sourceforge.net/projects/openmandriva/files/release/4.2/Final/OpenMandrivaLx.4.2-plasma.x86_64.iso/download) | kernel-devel | dnf |
| [openSUSE Tumbleweed](https://www.opensuse.org) | [20210408](https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Current.iso) | kernel-devel | zypper |
| [Parrot OS](https://parrotlinux.org) | [4.10 Home MATE](https://ftp.cc.uoc.gr/mirrors/linux/parrot/iso/4.10/Parrot-home-4.10_amd64.iso) | linux-headers-amd64 | apt |
| [PCLinuxOS](https://www.pclinuxos.com) | [2021.02](http://ftp.cc.uoc.gr/mirrors/linux/pclinuxos/pclinuxos/live-cd/64bit/pclinuxos64-MATE-2021.02.iso) | kernel-devel | apt-rpm |
| [Peppermint OS](https://peppermintos.com) | [10](https://github.com/peppermintos/Peppermint-10/releases/download/10_20191210/Peppermint-10-20191210-i386.iso) | linux-headers-generic-hwe-18.04 | apt |
| [Pop! OS](https://pop.system76.com) | [20.10](https://pop-iso.sfo2.cdn.digitaloceanspaces.com/20.10/amd64/intel/14/pop-os_20.10_amd64_intel_14.iso) | linux-headers-generic | apt |
| [PureOS](https://pureos.net) | [Hephaestus 9.0](https://downloads.pureos.net/amber/live/gnome/2020-08-06/pureos-9.0-gnome-live_20200806-amd64.hybrid.iso) | linux-headers-amd64 | apt |
| [Q4OS](https://q4os.org) | [3.12 Centaurus](https://jztkft.dl.sourceforge.net/project/q4os/stable/q4os-3.12-x64.r4.iso) | linux-headers-amd64 | apt |
| [Raspberry Pi OS](https://www.raspberrypi.org) | [10 Buster](https://downloads.raspberrypi.org/raspios_full_armhf/images/raspios_full_armhf-2021-03-25/2021-03-04-raspios-buster-armhf-full.zip) | raspberrypi-kernel-headers | apt |
| [Reborn OS](https://rebornos.org) | [2021.04.22](https://master.dl.sourceforge.net/project/rebornos/RebornOS-2021.04.22-x86_64.iso?viasf=1) | linux-headers | pacman |
| [Scientific Linux](https://scientificlinux.org) | [7](http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/iso/SL-79-x86_64-2020-10-17-LiveCD.iso) | kernel-devel | yum |
| [Slackware](https://www.slackware.com) | [14.2](https://slackware.nl/slackware/slackware-live/slackware64-14.2-live/slackware64-live-14.2.iso) | kernel-headers-5.10.30-x86-1 | pkgtool, see note 3 |
| [Solus](https://getsol.us) | [4.2](https://mirrors.rit.edu/solus/images/4.2/Solus-4.2-Budgie.iso) | linux-current-headers | eopkg |
| [SparkyLinux](https://sparkylinux.org) | [5.12](https://vorboss.dl.sourceforge.net/project/sparkylinux/lxqt/sparkylinux-5.12-x86_64-lxqt.iso) | linux-headers-amd64 | apt |
| [Trisquel](https://trisquel.info) | [9.0](https://mirror.linux.pizza/trisquel/images//trisquel-mini_9.0_amd64.iso) | linux-headers-generic | apt |
| [Ultimate Edition](http://ultimateedition.info) | [6.6](https://kumisystems.dl.sourceforge.net/project/ultimateedition/ultimate-edition-6.6-x64-gamers-xfce.iso) | linux-headers-generic | apt |
| [Void Linux](https://voidlinux.org) | [20210218](https://alpha.de.repo.voidlinux.org/live/current/void-live-x86_64-20210218-enlightenment.iso) | linux-headers | xbps |
| [Voyager](https://voyagerlive.org) | [20.04](https://netix.dl.sourceforge.net/project/voyagerlive/Voyager-20.04.2-LTS-amd64.iso) | linux-headers-generic | apt |
| [Zorin OS](https://zorinos.com) | [15.3 Lite](https://netix.dl.sourceforge.net/project/zorin-os/15/Zorin-OS-15.3-Lite-64-bit.iso) | linux-headers-generic-hwe-18.04 | apt |

## Notes

> 📝 **Note** that if you are not satisfied with the level of support that we are able to offer for your distribution, you may return the adapter back to Amazon for a refund, as it comes with a 2 year warranty.

1. **AntiX Linux** has a broken pkexec, so our installation command should use sudo instead:

    ```shell
    sh -c 'wget deb.trendtechcn.com/install -O /tmp/install && sudo sh /tmp/install'
    ```

2. **Manjaro Linux** shows a prompt about which kernel headers to install; please select the matching one, for example if your kernel is 5.10 then choose the linux510-headers package.

3. **Slackware** doesn't include dkms in its stock repositories; if you're frequently changing kernels, you can [optionally install it](https://slackware.pkgs.org/current/slackers/dkms-2.8.4-x86_64-1cf.txz.html)

See also the [unsupported distributions](../unsupported-distributions/) list.
