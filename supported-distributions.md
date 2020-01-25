---
nav_order: 2
---

# Supported distributions

This page divides the Linux distributions in three cases: the (bigger Debian based) ones that we officially support, the (smaller Debian based) ones that we try to support unofficially, and the (non Debian based) ones where our driver does not work.

## Officially supported

We make sure that our driver works in all the official Debian, Ubuntu and Raspbian current distributions.

- The official Ubuntu flavors are listed [here](https://wiki.ubuntu.com/UbuntuFlavors): Ubuntu, Kubuntu, Lubuntu, Xubuntu, Ubuntu MATE, Budgie and Kylin, and their EOL (End Of Life) [here](https://wiki.ubuntu.com/Releases). This means that for example Ubuntu no longer officially supports their 19.04 version, and that Linux Mint is not an official flavor.
- The offical Debian blends are listed [here](https://www.debian.org/blends/) and their EOL [here](https://wiki.debian.org/DebianReleases); we regularly test oldstable (Stretch) and stable (Buster). This means that for example Kali and OSMC aren't official Debian blends.
- The Raspbian EOL is the same as for Debian; again there we test oldstable and stable.

## Unofficially supported

There are dozens of Debian based distributions where our driver probably works, but they are too many for our team to officially test all of them. Additionally, some distributions like LinuxMint impose restrictions like apt-pinning their kernels, and others like Kali offer custom kernels. The main issue is to get the kernel headers; if those are available, then our installer can properly compile our driver.

Our users report that our driver works in the following distributions:

- [Debian based](https://en.wikipedia.org/wiki/Category:Debian-based_distributions): e.g. Linux Mint, Kali, MX Linux, PureOS.

## Unsupported

> 📝 **Note** that if your distribution is unsupported and you didn't notice it and you purchased our adapter, you may ask for a refund, as our product comes with a 2 year warranty.

We currently do not test nor support our driver in the following distributions. Yet, it's possible to uncompress the .deb and compile the driver from source, if one has the necessary know-how:

- [RPM based](https://en.wikipedia.org/wiki/Category:RPM-based_Linux_distributions): e.g. CentOS, Fedora, Mageia, Mandriva, OpenSUSE, SUSE.
- [Arch based](https://wiki.archlinux.org/index.php/Arch-based_distributions): e.g. Arch, Manjaro, Antergos, Artix
- [Source based](https://en.wikipedia.org/wiki/Category:Source-based_Linux_distributions): e.g. Gentoo
