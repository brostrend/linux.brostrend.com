#!/bin/sh
# Copyright 2018-2026 Alkis Georgopoulos <github.com/alkisg>
# SPDX-License-Identifier: GPL-3.0-or-later

usage() {
    printf "Usage: %s [OPTIONS] [COMMAND]

Install the drivers for the BrosTrend network adapters.
The main difficulty is in detecting the appropriate kernel *headers* package.

Options:
    -h  Show this help message.
    -p  Pause on exit.
    -t  Gather troubleshoting information.
" "$0"
}

bold() {
    if [ "$_PRINTBOLD_FIRST_TIME" != 1 ]; then
        _PRINTBOLD_FIRST_TIME=1
        _BOLD_FACE=$(tput bold 2>/dev/null) || true
        _NORMAL_FACE=$(tput sgr0 2>/dev/null) || true
    fi
    if [ "$1" = "-n" ]; then
        shift
        printf "%s" "${_BOLD_FACE}$*${_NORMAL_FACE}"
    else
        printf "%s\n" "${_BOLD_FACE}$*${_NORMAL_FACE}"
    fi
}

# For the external tools we need that are also provided by busybox,
# if some tool doesn't exist, create a namesake function that calls busybox.
# `/usr/lib/initramfs-tools/bin/busybox` shows the smallest list of tools.
busybox_fallbacks() {
    local busybox tool

    busybox=$(command -v busybox)
    # Ubuntu chroots ship with a "busybox-initramfs" minimal package
    if [ -z "$busybox" ] && [ -x /usr/lib/initramfs-tools/bin/busybox ]; then
        busybox=/usr/lib/initramfs-tools/bin/busybox
    fi
    test -n "$busybox" || return 0
    for tool in awk blockdev cat chgrp chmod chown chroot chvt cp \
        cpio cut date df env expr find getopt grep head hostname id \
        insmod ionice ip kill killall ln logger losetup ls lsmod \
        mkdir mktemp modprobe mount mv nc netstat pidof ping \
        poweroff ps pwd readlink rm rmdir rmmod sed setsid sleep sort \
        swapoff swapon switch_root sync tee touch tr truncate umount \
        uname wc; do
        # Periodically, prefix a "true" to the following line and test all
        # applets to see if we are indeed compatible with the busybox syntax
        ! is_command "$tool" || continue
        eval "$tool() {
    $busybox $tool \"\$@\"
}"
    done
}

# Set $_DRIVER, based on the script filename, or the inserted adapter,
# or the user input.
select_driver() {
    local fname product _dummy choice

    fname=${0##*/}
    fname=${fname%.sh}
    set --
    case "$fname" in
    8812au | 88x2bu | 8821cu | 8852bu | 8852cu) set "rtl$fname" ;;
    aic8800 | r8152) set "$fname" ;;
    esac
    # We want to install a single driver on each invocation of the installer
    while [ $# -ne 1 ]; do
        while read -r product _dummy; do
            case "$product" in
            0bda:815[67a]) set -- r8152 ;;
            0bda:8812) set -- "$@" rtl8812au ;;
            0bda:b812) set -- "$@" rtl88x2bu ;;
            0bda:c811) set -- "$@" rtl8821cu ;;
            0bda:b832) set -- "$@" rtl8852bu ;;
            0bda:c832) set -- "$@" rtl8852cu ;;
            0bda:1a2b)
                bold "Switching the adapter from storage to WLAN mode"
                # Wait to see which one of the Realtek adapters it is
                re usb_modeswitch -KQ -v 0bda -p 1a2b
                # If another adapter was detected, we'll re-discover it too
                set --
                continue 2
                ;;
            a69c:5721 | a69c:5723 | a69c:5725)
                set -- "$@" aic8800
                bold "Switching the adapter from storage to WLAN mode"
                # Background it as it can take up to 30 seconds in a VM
                rw usb_modeswitch -KQ -v a69c -p "${product#*:}" &
                ;;
            368b:88df | 368b:8d83 | 368b:8d8c | a69c:8d80)
                set -- "$@" aic8800
                ;;
            0e8d:7961) bold "NOTE: the AX9L adapter does not need a driver, see:
https://linux.brostrend.com/supported-distributions/#in-kernel-drivers" ;;
            0bda:8912) bold "NOTE: the BE1L adapter does not need a driver, see:
https://linux.brostrend.com/supported-distributions/#in-kernel-drivers" ;;
            0bda:b851) bold "NOTE: the WB1L adapter does not need a driver, see:
https://linux.brostrend.com/supported-distributions/#in-kernel-drivers" ;;
            esac
        done <<EOF
$(lsusb_)
EOF
        # Merge multiple occurrences of the same driver into one
        # shellcheck disable=SC2046
        set -- $(printf "%s\n" "$@" | sort -u)
        echo "Autodetected drivers to be installed: $*"
        test $# -eq 1 && break
        if [ $# -eq 0 ]; then
            warn "Could not detect the adapter!"
            echo "Please insert the BrosTrend network adapter into a USB slot
and press [Enter] to retry the autodetection process.
If you don't have the adapter currently, you may type:"
        else
            warn "Many of our adapters are currently connected in USB slots!"
            echo "Either only leave the one you want to install connected,
and press [Enter] to retry the autodetection process,
or choose the driver you want to install from the following list:"
        fi
        echo "  1) r8152 for U6 (10G), U5/U5A (5G), U2/U2C (2G USB Ethernet)
  2) 8852cu for AX8L (AXE5400 USB Wi-Fi)
  3) aic8800 for AX7L/AX7LP (AX900), AX5L (AX300)
  4) 8852bu for AX1L/AX4L (AX1800)
  5) 8821cu for AC5L (AX300)
  6) 88x2bu for AC1L/AC3L v2 (current AC1200)
  7) 8812au for AC1L/AC3L v1 (old AC1200, before 2019)
  0) to quit without installing a driver"
        warn -n "Please type your choice, or [Enter] to autodetect: "
        read -r choice
        case "$choice" in
        1*) set r8152 ;;
        2*) set rtl8852cu ;;
        3*) set aic8800 ;;
        4*) set rtl8852bu ;;
        5*) set rtl8821cu ;;
        6*) set rtl88x2bu ;;
        7*) set rtl8812au ;;
        0*) die "Aborted" ;;
        # Anything else does autodetection again
        esac
    done
    case "$1" in
    r8152) _IKD=r8152 ;;
    rtl8812au) _IKD=rtw88_8812au ;;
    rtl88x2bu) _IKD=rtw88_8822bu ;;
    rtl8821cu) _IKD=rtw88_8821cu ;;
    rtl8852bu) _IKD=rtw89_8852bu ;;
    rtl8852cu) _IKD=rtw89_8852cu ;;
    *) _IKD= ;;
    esac
    if [ -n "$_IKD" ] && [ -d "/sys/module/$_IKD" ]; then
        warn "Your kernel already has a driver for this adapter!"
        echo "It is recommended that you abort our installer
and that you use the in-kernel driver instead; it should work out of the box:
https://linux.brostrend.com/supported-distributions/#in-kernel-drivers"
        warn -n "Press Ctrl+C to abort, or [Enter] to continue with the installation: "
        read -r choice
    fi
    _DRIVER=$1
}

detect_package_manager() {
    for _PM in apt-get dnf eopkg pacman pkgtool ppm swupd yum xbps-install zypper unknown; do
        if is_command "$_PM"; then
            if [ "$_PM" = "apt-get" ] && ! is_command dpkg && is_command rpm; then
                # ALT, PCLinuxOS, Vine: https://en.wikipedia.org/wiki/APT-RPM
                _PM=apt-rpm
            fi
            break
        fi
    done
    bold "Package manager is: $_PM"
}

# Output a message to stderr and abort execution
die() {
    warn "$@"
    pause_exit 1
}

# Download a file from the Internet
download() {
    if is_command wget; then
        re wget --no-check-certificate -nv "$@"
    elif is_command curl; then
        re curl --insecure -O "$@"
    elif is_command busybox; then
        # busybox wget supports --no-check-certificate since 20.04, no point
        re busybox wget -nv "$@"
    else
        die "Please install wget or curl and then re-run the installer"
    fi
}

install_debian_prerequisites() {
    local kernel header headers

    rw apt-get update
    # If the appropriate headers are already installed, return
    test -d "/lib/modules/$(uname -r)/build" && return 0

    # Possible image metapackage names:
    # Ubuntu: https://packages.ubuntu.com/source/focal/linux-meta
    # E.g. linux-image-generic, linux-image-lowlatency-hwe-18.04
    # Debian: https://packages.debian.org/source/buster/linux-latest
    # E.g. linux-image-686, linux-image-amd64, linux-image-armmp
    # Nvidia Jetson: nvidia-l4t-kernel, nvidia-l4t-kernel-headers
    # ODROID-XU4: linux-odroid-5422 (Bionic, 4.14.165-172, armv7l, includes headers)
    # OSMC: rbp2-kernel-osmc, rbp2-image-4.19.55-6-osmc, rbp2-headers-4.19.55-6-osmc
    # Proxmox: pve-kernel-5.4, pve-kernel5.15, pve-headers
    # Raspberry Pi OS: raspberrypi-kernel

    headers=""
    # We can't use `dpkg -S .../modules.builtin` as -hwe are metapackages.
    # So we use `dpkg -l linux-image-[^.][^.][^.]*` to avoid linux-image-5.11
    # but include linux-image-hwe-18.04.
    # The [hi] part is for held kernel packages, e.g. moodleaudio.org
    for kernel in $(dpkg -l 'linux-image[^.][^.][^.]*' nvidia-l4t-kernel proxmox-default-kernel 'pve-kernel*[^a-z]' raspberrypi-kernel 2>/dev/null |
        awk '/^[hi]i/ { print $2 }'); do
        case "$kernel" in
        nvidia-l4t-kernel)
            header=nvidia-l4t-kernel-headers
            ;;
        proxmox-default-kernel)
            header=proxmox-default-headers
            ;;
        pve-kernel*)
            # That's their older name
            header=pve-headers
            ;;
        raspberrypi-kernel)
            header=raspberrypi-kernel-headers
            ;;
        *)
            header=$(echo "$kernel" | sed 's/image/headers/')
            ;;
        esac
        if apt-cache policy "$header" | grep -q '[0-9]'; then
            headers="$headers $header"
        fi
    done
    if [ -n "$headers" ]; then
        bold "Installing kernel headers:$headers"
        re apt-get install --yes $headers
    else
        request_info "Couldn't detect the appropriate kernel headers package!" \
            dpkg -S "/lib/modules/$(uname -r)"
    fi
}

install_driver() {
    local module reinstall ver

    case "$_DRIVER" in
    rtl*) module=${_DRIVER#rtl} ;;
    r8152) module=r8152 ;;
    *) module=aic8800_fdrv ;;
    esac
    bold "Downloading the $_DRIVER driver"
    re cd "$(mktemp -d)"
    # Avoid the "Download is performed unsandboxed" apt warning
    re chmod 755 .
    download "https://linux.brostrend.com/$_DRIVER-dkms.deb"
    bold "Installing and compiling the driver"
    case "$_PM" in
    apt-get)
        # Prefer apt, but fall back to dpkg if necessary
        if dpkg --compare-versions "$(dpkg-query -W apt | awk '{ print $2 }')" gt 1.2; then
            # Avoid "Internal Error, No filename for..." error on ^iF
            if dpkg -l "$_DRIVER-dkms" | grep -q ^ii; then
                reinstall=--reinstall
            else
                unset reinstall
            fi
            # We want --no-install-recommends here because dkms in Debian
            # recommends a lot of kernel header packages that we may not require.
            # Caution, linuxmint uses a wrapper that can run `apt install --yes`
            # but it doesn't understand `apt --yes install`. Meh.
            re apt install $reinstall --yes --no-install-recommends \
                "./$_DRIVER-dkms.deb"
        else
            # The downside of using dpkg instead of apt is that dkms etc
            # will be marked as "manually installed".
            re apt-get install --yes --no-install-recommends \
                bc dkms libc6-dev linux-libc-dev
            re dpkg -i "./$_DRIVER-dkms.deb"
        fi
        ;;
    *)
        re ar x "$_DRIVER-dkms.deb"
        re tar xf data.tar.gz
        ver=$(echo usr/src/*-*)
        ver=${ver##*-}
        re rm -rf "/usr/src/$_DRIVER-$ver"
        re mv "usr/src/$_DRIVER-$ver" /usr/src/
        # TODO: to support r8152 and aic8800, we also need the udev rules
        re cd "/usr/src/$_DRIVER-$ver"
        if is_command dkms; then
            dkms remove -m "$_DRIVER" -v "$ver" --all 2>/dev/null
            rw dkms add -m "$_DRIVER" -v "$ver"
            re dkms build -m "$_DRIVER" -v "$ver"
            re dkms install -m "$_DRIVER" -v "$ver"
        else
            bold "Compiling without dkms..."
            re make
            re make install
        fi
        # Install the conf file which blacklists the in-kernel drivers
        if [ -L "/etc/modprobe.d/$module.conf" ]; then
            rm -f "/etc/modprobe.d/$module.conf"
        fi
        link="/usr/src/$_DRIVER-$ver/$module.conf"
        if [ -f "$link" ] &&
            [ -d /etc/modprobe.d ] &&
            [ ! -e "/etc/modprobe.d/$_DRIVER.conf" ]; then
            re ln -s "$link" /etc/modprobe.d/
        fi
        ;;
    esac
    # Unload the competing in-kernel drivers
    if [ "$_DRIVER" = "r8152" ]; then
        warn "Please reboot for the r8152 driver to get loaded"
    else
        if [ -n "$_IKD" ] && [ -d "/sys/module/$_IKD" ]; then
            bold "Unloading the $_IKD in-kernel driver"
            if ! timeout 10 modprobe -r "$_IKD"; then
                warn "Failed to unload the $_IKD in-kernel driver, PLEASE REBOOT"
            fi
        fi
        re modprobe "$module"
    fi
}

# Install missing packages from the ones specified
# $1: package manager command
# $*: packages
# If "cmd:package" is passed and missing, return "package".
# If "headers:package" is passed, check for the running kernel headers.
inmp() {
    local pmcmd
    local var cmd package
    local list

    pmcmd=$1
    shift
    list=""
    for var; do
        IFS=":" read -r cmd package <<EOF
$var
EOF
        package=${package:-$cmd}
        if [ "$cmd" = headers ]; then
            if [ ! -d "/lib/modules/$(uname -r)/build" ]; then
                list="$list $package"
            fi
        elif ! is_command "$cmd"; then
            list="$list $package"
        fi
    done
    if [ -n "$list" ]; then
        bold "Running: $pmcmd$list"
        if [ "$pmcmd" = "unknown" ]; then
            request_info "Unsupported distribution!
Install dependencies manually: ar bc gcc make tar linux-headers
Please see: https://linux.brostrend.com/supported-distributions" \
                cat /etc/os-release
        else
            # shellcheck disable=SC2086
            re $pmcmd $list
        fi
    fi
}

# The prerequisites are:
# ar:binutils bc elfutils-libelf-devel gcc make tar headers:kernel-devel
# elfutils-libelf-devel too for rpm dists, see https://bugs.debian.org/886474
# dkms satisfies all of them except for bc
install_prerequisites() {
    local var

    bold "Installing prerequisites"
    case "$_PM" in
    # TODO: see variations in https://github.com/morrownr/88x2bu-20210702
    apt-get | apt-rpm)
        install_debian_prerequisites
        ;;
    dnf | yum | zypper)
        # Examples of `rpm -qf "/boot/vmlinuz-$(uname -r)"`:
        # CentOS Linux 8: kernel-core-4.18.0-348.7.1.el8_5.x86_64
        # CentOS Linux 8 -lt: kernel-lt-core-5.4.240-1.el8.elrepo.x86_64
        # fedora-37: kernel-core-6.1.18-200.fc37.x86_64
        # fedora-38: kernel-modules-core-6.2.11-300.fc38.x86_64
        # openSUSE Leap 15.3: kernel-default-5.3.18-150300.59.106.1.x86_64
        # Transform them to e.g.: kernel-devel, kernel-lt-devel, -ml, -uek,
        # kernel-default-devel
        var=$(rpm -qf "/boot/vmlinuz-$(uname -r)") ||
            request_info "Unknown kernel"
        var=$(echo "$var" | grep -o 'kernel-[-[:alpha:]]*')
        var=${var%core-}
        var=${var%modules-}
        var="${var}devel"
        if [ "$_PM" = "zypper" ]; then
            inmp "zypper install -y" bc dkms "headers:$var"
        else
            # RHEL-based distributions might not provide dkms
            if "$_PM" list dkms >/dev/null 2>&1; then
                inmp "$_PM install -y" bc dkms "headers:$var"
            else
                inmp "$_PM install -y" ar:binutils bc :elfutils-libelf-devel gcc make tar "headers:$var"
            fi
        fi
        ;;
    eopkg)
        re eopkg update-repo
        inmp "eopkg install" ar:binutils bc gcc make tar headers:linux-current-headers
        ;;
    pacman)
        # In Manjaro, select the current kernel, not the old linux316-headers:
        inmp "pacman -Sy" bc dkms headers:linux-headers
        ;;
    swupd)
        # https://docs.01.org/clearlinux/latest/guides/kernel/kernel-modules-dkms.html
        var="$(uname -r)"
        var=${var##*.}
        inmp "swupd bundle-add" bc dkms:"kernel-$var-dkms"
        ;;
    xbps-install)
        inmp "xbps-install -S" bc dkms
        ;;
    *)
        inmp "unknown" bc ar bc gcc make tar headers
        ;;
    esac
}

# Check if parameter is a command; `command -v` isn't allowed by POSIX
is_command() {
    local fun

    if [ -z "$_IS_COMMAND" ]; then
        command -v is_command >/dev/null ||
            die "Your shell doesn't support command -v"
        _IS_COMMAND=1
    fi
    for fun in "$@"; do
        command -v "$fun" >/dev/null || return $?
    done
}

# Return true if the kernel is at least that version
kver() {
    if [ -z "$_UNAME_R" ]; then
        _UNAME_R=$(uname -r)
    fi
    test "$(printf "%s\n%s\n" "$_UNAME_R" "$1" | sort -rV | head -n1)" = "$_UNAME_R" ||
        return $?
}

# Implement lsusb as it isn't preinstalled in some distributions
# Return only the Brostrend devices
# Typical lsusb descriptions (/var/lib/usbutils/usb.ids):
# AC1,3Lv1: ID 0bda:8812 Realtek Semiconductor Corp.
#           RTL8812AU 802.11a/b/g/n/ac 2T2R DB WLAN Adapter
# AC1,3Lv2: ID 0bda:b812 Realtek Semiconductor Corp. RTL88x2bu [AC1200 Techkey]
# AC5L:     ID 0bda:c811 Realtek Semiconductor Corp. 802.11ac NIC
# ©:        The indicated Realtek adapters also have this CDROM mode:
#           ID 0bda:1a2b Realtek Semiconductor Corp.
#           RTL8188GU 802.11n WLAN Adapter (Driver CDROM Mode)
# AX1,4L©:  ID 0bda:b832 Realtek Semiconductor Corp. 802.11ax WLAN Adapter
# AX5L:     ID 368b:88df AICSemi AIC8800DC
# AX5Lst:   ID a69c:5721 aicsemi Aic MSC
# AX7L:     ID 368b:8d83 AICSemi AIC 8800D80
# AX7Lej:   ID a69c:8d80 aicsemi AIC Wlan (after eject, before firmware)
# AX7Lst:   ID a69c:5723 aicsemi Aic MSC
# AX7PL:    ID 368b:8d8c AICSemi AIC 8800D80
# AX7PLej:  ID a69c:8d80 aicsemi AIC Wlan (after eject, before firmware)
# AX7PLst:  ID a69c:5725 aicsemi Aic MSC
# AX8L©:    ID 0bda:c832 Realtek Semiconductor Corp. 802.11ax WLAN Adapter
# AX9L:     ID 0e8d:7961 MediaTek Inc. Wireless_Device
# BE1L©:    ID 0bda:8912 Realtek Semiconductor Corp. 802.11be WLAN Adapter
# WB1L©:    ID 0bda:b851 Realtek Semiconductor Corp. 802.11ax WLAN Adapter
# U2, U2C:  ID 0bda:8156 Realtek Semiconductor Corp. USB 10/100/1G/2.5G/5G/10G LAN
# U5, U5A:  ID 0bda:8157 Realtek Semiconductor Corp. USB 10/100/1G/2.5G/5G/10G LAN
# U6:       ID 0bda:815a Realtek Semiconductor Corp. USB 10/100/1G/2.5G/5G/10G LAN
# The manufacturer:product description is too bare. Just use our own.
lsusb_() {
    local fname fdir usbid msg speed

    for fname in /sys/bus/usb/devices/*/idVendor; do
        fdir=${fname%/*}
        usbid="$(cat "$fname"):$(cat "$fdir/idProduct")"
        # Return only our own devices
        case "$usbid" in
        0bda:8812) msg="Brostrend AC1Lv1/AC3Lv1 Wi-Fi adapter" ;;
        0bda:b812) msg="Brostrend AC1L/AC3L Wi-Fi adapter" ;;
        0bda:c811) msg="Brostrend AC5L Wi-Fi adapter" ;;
        0bda:1a2b) msg="Brostrend Realtek Wi-Fi adapter (storage mode)" ;;
        0bda:b832) msg="Brostrend AX1L/AX4L Wi-Fi adapter" ;;
        368b:88df) msg="Brostrend AX5L Wi-Fi adapter" ;;
        a69c:5721) msg="Brostrend AX5L Wi-Fi adapter (storage mode)" ;;
        368b:8d83) msg="Brostrend AX7L Wi-Fi adapter" ;;
        a69c:8d80) msg="Brostrend AX7L/AX7PL Wi-Fi adapter (ejected mode)" ;;
        a69c:5723) msg="Brostrend AX7L Wi-Fi adapter (storage mode)" ;;
        368b:8d8c) msg="Brostrend AX7PL Wi-Fi adapter" ;;
        a69c:5725) msg="Brostrend AX7PL Wi-Fi adapter (storage mode)" ;;
        0bda:c832) msg="Brostrend AX8L Wi-Fi adapter" ;;
        0e8d:7961) msg="Brostrend AX9L Wi-Fi adapter" ;;
        0bda:8912) msg="Brostrend BE1L Wi-Fi adapter" ;;
        0bda:b851) msg="Brostrend WB1L Wi-Fi adapter" ;;
        0bda:8156) msg="Brostrend U2/U2C USB Ethernet adapter" ;;
        0bda:8157) msg="Brostrend U5/U5A USB Ethernet adapter" ;;
        0bda:815a) msg="Brostrend U6 USB Ethernet adapter" ;;
        *) continue ;;
        esac
        case "$(cat "$fdir/speed" 2>/dev/null)" in
        1.5 | 12) speed="USB 1" ;;
        480) speed="USB 2" ;;
        5000) speed="USB 3" ;;
        10000) speed="USB 3.1" ;;
        *0000) speed="USB 3.2+" ;;
        *) speed="" ;;
        esac
        if [ -n "$speed" ]; then
            case "$msg" in
            *')') msg="${msg%)}, $speed)" ;;
            *) msg="$msg ($speed)" ;;
            esac
        fi
        echo "$usbid $msg"
    done
}

pause_exit() {
    local _dummy

    if [ "$_PAUSE_ON_EXIT" = 1 ]; then
        warn -n "Press [Enter] to close the current window."
        read -r _dummy
    fi
    exit "${1:-0}"
}

re() {
    "$@" || request_info "Aborting, command failed: $*"
}

request_info() {
    if [ -n "$1" ]; then
        echo "$1" >&2
        shift
    fi
    troubleshoot >/tmp/brostrend.log.txt 2>&1
    if [ $# -gt 0 ]; then
        rt "$@" >>/tmp/brostrend.log.txt
    fi
    die "
===================================================
 ERROR: The driver was NOT successfully installed!
===================================================
1) Please select ALL the text in this terminal, then right click with the
   mouse and select Copy, and finally paste all the text in an email to:
   support@brostrend.com
2) Please also attach this autogenerated log file to the email:
   /tmp/brostrend.log.txt
   If you want to view it, run:
   xdg-open /tmp/brostrend.log.txt
3) Some common issues are documented in:
   https://linux.brostrend.com/troubleshooting/"
}

rw() {
    "$@" || echo "Warning, command failed: $*" >&2
}

# Echo and run a troubleshooting command, and log its output
rt() {
    local fflag iflag eflag

    while [ -n "$1" ]; do
        case "$1" in
        -f) fflag=1 ;;
        -i) iflag=1 ;;
        -e) eflag=1 ;;
        *) break ;;
        esac
        shift
    done
    # Check if the binary doesn't exist, e.g. apt on Fedora
    if [ "$fflag" = 1 ]; then
        # And either return failure,
        is_command "$1" || return 1
    elif [ "$iflag" = 1 ]; then
        # ...or ignore it and return success
        is_command "$1" || return 0
    fi
    printf "\n# %s\n" "$*"
    if [ "$eflag" = 1 ]; then
        # Use eval, e.g. for `command 1 | command 2`
        eval "$*" || return $?
    else
        "$@" || return $?
    fi
}

troubleshoot() {
    echo "Troubleshooting information collected on $(date)"
    rt uname -a
    rt uptime
    rt grep PRETTY /etc/os-release
    rt -i dpkg --print-architecture
    rt lsusb_
    rt -f -e lsmod "| grep ^cfg80211" ||
        rt -e ls /sys/module/cfg80211/holders/
    rt -i -e rfkill list
    rt -i -e mokutil --sb-state
    rt -f dkms status || rt -i apt policy dkms
    rt -i -e dpkg "-l '*-dkms' | grep ^ii"
    rt ip a
    rt ls -d /lib/modules/*/build /usr/src/linux-headers-*
    rt -f dpkg -S /boot /lib/modules /usr/src/ ||
        rt -i rpm -qf /boot/vmlinu* /lib/modules/* /usr/src/*
    # iw isn't available in vanilla Ubuntu GNOME 22.04, but iwlist is
    rt -i iw reg get
    rt -f nmcli dev wifi || rt -i iwlist scanning
    rt -i lsusb -tv
    rt -i free
    # Try the faster variant, fallback to the safer one
    SYSTEMD_COLORS=16 rt -f journalctl -b -n 5000 ||
        rt "dmesg --color=always | tail -n 5000"
}

warn() {
    bold "$@" >&2
}

main() {
    local title scriptpath

    case "$1" in
    "") ;;
    -p) _PAUSE_ON_EXIT=1 ;;
    -t) _TROUBLESHOOT=1 ;;
    *)
        usage
        exit 0
        ;;
    esac

    # First check if we need to spawn an x-terminal-emulator.
    # Note that after pkexec we don't have access to $DISPLAY.
    if [ "$_PAUSE_ON_EXIT" != 1 ] && { [ ! -t 0 ] || [ ! -t 1 ]; } &&
        xmodmap -n >/dev/null 2>&1; then
        title=${1##*/}
        case "$title" in
        -s | --source) title=${2##*/} ;;
        '') title=${0##*/} ;;
        esac
        _PAUSE_ON_EXIT=1 exec x-terminal-emulator -T "$title" -e sh "$0" "$@"
    fi

    # Get root access if we don't already have it
    if [ "$(id -u)" -ne 0 ]; then
        # Make the installer executable, in case it was downloaded from the web.
        scriptpath="$(
            cd "$(dirname "$0")"
            pwd -P
        )/$(basename "$0")"
        test -x "$scriptpath" || chmod +x "$scriptpath"
        test -x "$scriptpath" || die "Could not make $scriptpath executable"

        bold "Root access is required"
        # Prefer sudo when available, to avoid pkexec-over-ssh issues:
        # https://gitlab.freedesktop.org/polkit/polkit/-/issues/17
        if groups | grep -qwE 'sudo|wheel' && is_command sudo; then
            exec sudo "$scriptpath" ${_PAUSE_ON_EXIT:+-p} "$@"
        else
            # TODO: for some reason, a delay is needed here, otherwise pkexec might not appear!
            sleep 1
            exec pkexec "$scriptpath" ${_PAUSE_ON_EXIT:+-p} "$@"
        fi
    fi

    # Tolerate users using `su` instead of `su -`
    if ! echo "$PATH" | grep -qw sbin; then
        export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    fi
    busybox_fallbacks
    if [ "$_TROUBLESHOOT" = "1" ]; then
        troubleshoot >/tmp/brostrend.log.txt 2>&1
        die "The troubleshooting information was saved in this file:
    /tmp/brostrend.log.txt
If you want to view it, run:
    xdg-open /tmp/brostrend.log.txt
Please attach that file in an email to:
    support@brostrend.com"
    fi
    select_driver
    detect_package_manager
    install_prerequisites
    install_driver
    bold "
=====================================================
 The driver was successfully installed!
 We'd appreciate an Amazon product review:
 https://www.amazon.com/review/create-review/listing
====================================================="
    pause_exit
}

main "$@"
