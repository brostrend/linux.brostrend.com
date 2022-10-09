---
nav_order: 3
---

# Unsupported distributions

We try to support as many Linux distributions as possible. But there are so many that it's impossible to test all of them. Also, some do not provide the required kernel headers and build tools, or target exotic hardware that we don't have access to.

> 📝 **Note** that if your distribution is unsupported and you didn't notice it when you purchased our adapter, you may return the adapter back to Amazon for a refund, as it comes with a two-year warranty.

Here are some of the distributions that we tested where our installer either doesn't work at all, or it requires an unreasonable amount of effort:

| Distribution | Version | Headers package | Remarks |
|---|---|---|---|
| [CentOS Linux](https://www.centos.org) | [8](http://ftp.ntua.gr/pub/linux/centos/8.3.2011/isos/x86_64/CentOS-8.3.2011-x86_64-boot.iso) | kernel-devel | dnf, see note 1 |
| [CentOS Stream](https://www.centos.org) | [8](http://ftp.ntua.gr/pub/linux/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-20210415-boot.iso) | kernel-devel | dnf, see note 1 |
| [Endless OS](https://endlessos.com) | [Endless 3.8.7](eos-eos3.8-amd64-amd64.201005-194955.base.iso) | - | [ostree+flatpak](https://support.endlessos.org/en/help-center/How-can-I-add-tools-like-GCC-on-EOS), unsupported |
| [Guix](https://guix.gnu.org) | [1.3.0](https://ftp.gnu.org/gnu/guix/guix-system-vm-image-1.3.0.x86_64-linux.qcow2) | linux-libre-headers | No [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard), unsupported |
| [LibreELEC](https://libreelec.tv) | [10.0.2](https://releases.libreelec.tv/LibreELEC-RPi4.arm-10.0.2.img.gz) | - | Embedded, unsupported |
| [openSUSE Leap](https://www.opensuse.org) | [15.2](http://mirrors.netix.net/opensuse/distribution/leap/15.2/iso/openSUSE-Leap-15.2-NET-x86_64.iso) | kernel-devel | zypper, see note 2 |
| [Puppy Linux](http://puppylinux.com) | [FossaPup64 9.5](http://distro.ibiblio.org/puppylinux/puppy-fossa/fossapup64-9.5.iso) | kernel_sources-5.4.53-fossapup64.sfs | [ppm](http://wikka.puppylinux.com/PPM), [install devx.sfs first](https://oldforum.puppylinux.com/viewtopic.php?p=1033265&sid=82cf31e93c2ecd321ca75b610b794ced) |
| [Red Hat Enterprise Linux](https://www.redhat.com) | [8.3](https://access.cdn.redhat.com/content/origin/files/sha256/1b/1b73ebfebd1f9424c806032168873b067259d8b29f4e9d39ae0e4009cce49b93/rhel-8.3-x86_64-boot.iso) | kernel-devel | dnf, see note 1 |
| [Tails](https://tails.boum.org) | [4.17](https://tails.jason-m.net/tails/stable/tails-amd64-4.17/tails-amd64-4.17.iso) | linux-headers-amd64 | apt, live only, unsupported<!--doable with init=/bin/bash--> |
| [Tiny Core Linux](http://www.tinycorelinux.net/) | [12](http://www.tinycorelinux.net/12.x/x86/release/CorePlus-current.iso) | - | tcz, unsupported |
| [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install) | [WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install) | - | [VM, unsupported](https://github.com/microsoft/WSL/issues/7400) |

## Notes

1. **CentOS**  and **RHEL** backport some new features to older kernels, confusing the Realtek driver. Currently the driver can only work by installing the kernel-lt and kernel-lt-devel packages, which upgrade to thelong term support kernel (or the -ml ones which upgrade to the mainline kernel). Additionally, [dkms isn't included](https://access.redhat.com/solutions/1132653) in their stock repositories. Our driver can work without it, but it's best if you make it available.

    ```shell
    # Add the repository for dkms
    sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    # Add the repository for the -lt kernels
    sudo rpm -ivh https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
    # Install the -lt kernels
    sudo dnf install -y --enablerepo=elrepo-kernel kernel-lt kernel-lt-devel
    # Then reboot, then run our installer
    ```

2. **openSUSE Leap** backports some new features to older kernels, confusing the Realtek driver. Currently the driver is only supported on openSUSE Tumbleweed, which comes with a newer kernel.

See also the [supported distributions](../supported-distributions/) list.
