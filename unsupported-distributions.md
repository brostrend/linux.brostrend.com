---
nav_order: 3
---

# Unsupported distributions

We try to support as many Linux distributions as possible. But there are so many that it's impossible to test all of them. Also, some do not provide the required kernel headers and build tools, or target exotic hardware that we don't have access to.

> 📝 **Note** that if your distribution is unsupported and you didn't notice it when you purchased our adapter, you may return the adapter back to Amazon for a refund, as it comes with a two-year warranty.

Here are some of the distributions that we tested where our installer either doesn't work at all, or it requires an unreasonable amount of effort:

| Distribution | Version | Headers package | Remarks |
|---|---|---|---|
| [Endless OS](https://endlessos.com) | [Endless 3.8.7](eos-eos3.8-amd64-amd64.201005-194955.base.iso) | - | [ostree+flatpak](https://support.endlessos.org/en/help-center/How-can-I-add-tools-like-GCC-on-EOS), unsupported |
| [Guix](https://guix.gnu.org) | [1.3.0](https://ftp.gnu.org/gnu/guix/guix-system-vm-image-1.3.0.x86_64-linux.qcow2) | linux-libre-headers | No [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard), unsupported |
| [Puppy Linux](http://puppylinux.com) | [FossaPup64 9.5](http://distro.ibiblio.org/puppylinux/puppy-fossa/fossapup64-9.5.iso) | kernel_sources-5.4.53-fossapup64.sfs | [ppm](http://wikka.puppylinux.com/PPM), [install devx.sfs first](https://oldforum.puppylinux.com/viewtopic.php?p=1033265&sid=82cf31e93c2ecd321ca75b610b794ced) |
| [Tails](https://tails.boum.org) | [4.17](https://tails.jason-m.net/tails/stable/tails-amd64-4.17/tails-amd64-4.17.iso) | linux-headers-amd64 | apt, live only, unsupported<!--doable with init=/bin/bash--> |
| [Tiny Core Linux](http://www.tinycorelinux.net/) | [12](http://www.tinycorelinux.net/12.x/x86/release/CorePlus-current.iso) | - | tcz, unsupported

See also the [supported distributions](../supported-distributions/) list.
