#!/bin/sh
# Copyright 2018-2022 Alkis Georgopoulos <github.com/alkisg>
# SPDX-License-Identifier: GPL-3.0-or-later

usage() {
    printf "Usage: %s [OPTIONS] [COMMAND]

Install the drivers for the BrosTrend AC1L/AC3L/AC5L/AX1 adapters.
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

# Sets $_CHIP, based on the script filename, or the inserted adapter,
# or the user input.
# lsusb output:
# AC1Lv1: Bus 003 Device 008: ID 0bda:8812 Realtek Semiconductor Corp.
#         RTL8812AU 802.11a/b/g/n/ac WLAN Adapter
# AC3Lv2: Bus 003 Device 007: ID 0bda:b812 Realtek Semiconductor Corp.
# AC5L:   Bus 003 Device 027: ID 0bda:c811 Realtek Semiconductor Corp.
# AX1:    Bus 003 Device 027: ID 0bda:b832 Realtek Semiconductor Corp.
#         802.11ac WLAN Adapter
detect_adapter() {
    local fname product choice

    _CHIP=""
    fname=${0##*/}
    fname=${fname%.sh}
    case "$fname" in
    8812au | 88x2bu | 8821cu | 8852bu)
        _CHIP=$fname
        return 0
        ;;
    esac
    while [ -z "$_CHIP" ]; do
        # lsusb isn't available in e.g. buster-mate
        for fname in /sys/bus/usb/devices/*/idVendor; do
            product="$(cat "$fname"):$(cat "${fname%Vendor}Product")"
            case "$product" in
            0bda:8812) _CHIP=8812au ;;
            0bda:b812) _CHIP=88x2bu ;;
            0bda:c811) _CHIP=8821cu ;;
            0bda:b832) _CHIP=8852bu ;;
            esac
        done
        test -n "$_CHIP" && return 0
        bold "Could not detect the adapter!"
        echo "Please insert the BrosTrend WiFi adapter into a USB slot
and press [Enter] to continue.
If you don't have the adapter currently, you may type:
  (a) to install the 8812au driver for the old AC1L/AC3L models before 2019, or
  (b) to install the 88x2bu driver for the new AC1L/AC3L version 2 models, or
  (c) to install the 8821cu driver for the AC5L model, or
  (d) to install the 8852bu driver for the AX1L/AX4L models, or
  (q) to quit without installing a driver"
        bold -n "Please type your choice, or [Enter] to autodetect: "
        read -r choice
        case "$choice" in
        a) _CHIP=8812au ;;
        b) _CHIP=88x2bu ;;
        c) _CHIP=8821cu ;;
        d) _CHIP=8852bu ;;
        q) die "Aborted" ;;
        esac
    done
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
    bold "$@" >&2
    pause_exit 1
}

# Download a file from the Internet
download() {
    if is_command wget; then
        re wget --no-check-certificate -nv "$@"
    elif is_command curl; then
        re curl --insecure -O "$@"
    elif is_command busybox; then
        re busybox --no-check-certificate wget -nv "$@"
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
    # Raspberry Pi OS: raspberrypi-kernel
    # OSMC: rbp2-kernel-osmc, rbp2-image-4.19.55-6-osmc, rbp2-headers-4.19.55-6-osmc
    # ODROID-XU4: linux-odroid-5422 (Bionic, 4.14.165-172, armv7l, includes headers)

    headers=""
    # We can't use `dpkg -S .../modules.builtin` as -hwe are metapackages.
    # So we use `dpkg -l linux-image-[^.][^.][^.]*` to avoid linux-image-5.11
    # but include linux-image-hwe-18.04.
    for kernel in $(dpkg -l 'linux-image[^.][^.][^.]*' raspberrypi-kernel 2>/dev/null |
        awk '/^ii/ { print $2 }'); do
        case "$kernel" in
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
    local reinstall rtlversion

    bold "Downloading the driver"
    re cd "$(mktemp -d)"
    download "https://linux.brostrend.com/rtl$_CHIP-dkms.deb"
    bold "Installing and compiling the driver"
    case "$_PM" in
    apt-get)
        # Prefer apt, but fall back to dpkg if necessary
        if dpkg --compare-versions "$(dpkg-query -W apt | awk '{ print $2 }')" gt 1.2; then
            # Avoid "Internal Error, No filename for..." error on ^iF
            if dpkg -l "rtl$_CHIP-dkms" | grep -q ^ii; then
                reinstall=--reinstall
            else
                unset reinstall
            fi
            # We want --no-install-recommends here because dkms in Debian
            # recommends a lot of kernel header packages that we may not require.
            # Caution, linuxmint uses a wrapper that can run `apt install --yes`
            # but it doesn't understand `apt --yes install`. Meh.
            re apt install $reinstall --yes --no-install-recommends \
                "./rtl$_CHIP-dkms.deb"
        else
            # The downside of using dpkg instead of apt is that dkms etc
            # will be marked as "manually installed".
            re apt-get install --yes --no-install-recommends \
                bc dkms libc6-dev linux-libc-dev
            re dpkg -i "./rtl$_CHIP-dkms.deb"
        fi
        ;;
    *)
        re ar x "rtl$_CHIP-dkms.deb"
        re tar xf data.tar.gz
        rtlversion=$(echo usr/src/rtl*)
        rtlversion=${rtlversion##*-}
        re rm -rf "/usr/src/rtl$_CHIP-$rtlversion"
        re mv "usr/src/rtl$_CHIP-$rtlversion" /usr/src/
        re cd "/usr/src/rtl$_CHIP-$rtlversion"
        # source_workarounds
        if is_command dkms; then
            dkms remove -m "rtl$_CHIP" -v "$rtlversion" --all 2>/dev/null
            re dkms add -m "rtl$_CHIP" -v "$rtlversion"
            re dkms build -m "rtl$_CHIP" -v "$rtlversion"
            re dkms install -m "rtl$_CHIP" -v "$rtlversion"
        else
            bold "Compiling without dkms..."
            re make
            re make install
        fi
        ;;
    esac
    re modprobe "$_CHIP"
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
    apt-get | apt-rpm)
        install_debian_prerequisites
        ;;
    dnf | yum)
        # E.g. kernel-devel, kernel-lt-devel, -ml, -uek
        # Fedora returns kernel-core-version, remove -core
        var=$(rpm -qf "/lib/modules/$(uname -r)/modules.builtin" |
            sed 's/^\(kernel[-a-z]*\).*/\1devel/;s/-core-devel/-devel/') ||
            request_info "Unknown kernel"
        # RHEL-based distributions might not provide dkms
        if "$_PM" list dkms >/dev/null 2>&1; then
            inmp "$_PM install -y" bc dkms "headers:$var"
        else
            inmp "$_PM install -y" ar:binutils bc :elfutils-libelf-devel gcc make tar "headers:$var"
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
    zypper)
        # E.g. kernel-devel, kernel-default-devel
        var=$(rpm -qf "/lib/modules/$(uname -r)/modules.builtin" |
            sed 's/^\(kernel[-a-z]*\).*/\1devel/;s/-core-devel/-devel/') ||
            request_info "Unknown kernel"
        inmp "zypper install -y" bc dkms "headers:$var"
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

pause_exit() {
    local _dummy

    if [ "$_PAUSE_ON_EXIT" = 1 ]; then
        bold -n "Press [Enter] to close the current window."
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
    troubleshoot
    if [ $# -gt 0 ]; then
        {
            echo "$*"
            "$@"
        } >>/tmp/troubleshooting.txt
    fi
    die "
===================================================
 ERROR: The driver was NOT successfully installed!
===================================================
1) Please select all the text in this terminal, then right click with the
   mouse and select Copy, and finally paste all the text in an email to:
   support@brostrend.com
2) Please attach this autogenerated log file to the email:
   /tmp/troubleshooting.txt
3) Some common problems are documented in:
   https://linux.brostrend.com/troubleshooting/"
}

rw() {
    "$@" || echo "Warning, command failed: $*" >&2
}

source_workarounds() {
    if grep -qs 'NAME="CentOS Linux"' /etc/os-release && kver "4.18"; then
        bold "Applying source code workarounds for CentOS Linux"
        sed 's/5, 0, 0/4, 18, 0/' -i os_dep/linux/rtw_android.c
        sed 's/4, 19, 0/4, 18, 0/' -i os_dep/linux/os_intfs.c
    elif grep -qs 'NAME="CentOS Stream"' /etc/os-release && kver "4.18"; then
        bold "Applying source code workarounds for CentOS Stream"
        sed 's/5, 8, 0/4, 18, 0/' -i os_dep/linux/ioctl_cfg80211.c
        sed 's/5, 0, 0/4, 18, 0/' -i os_dep/linux/rtw_android.c
        sed 's/4, 19, 0/4, 18, 0/' -i os_dep/linux/os_intfs.c
    elif grep -qs 'ID="rhel"' /etc/os-release && kver "4.18"; then
        bold "Applying source code workarounds for RHEL"
        sed 's/5, 0, 0/4, 18, 0/' -i os_dep/linux/rtw_android.c
        sed 's/4, 19, 0/4, 18, 0/' -i os_dep/linux/os_intfs.c
    elif grep -qs 'ID="opensuse-leap"' /etc/os-release && kver "5.3"; then
        bold "Applying source code workarounds for openSUSE Leap"
        sed 's/5, 8, 0/5, 3, 0/' -i os_dep/linux/ioctl_cfg80211.c
    fi
}

troubleshoot() {
    while read -r line; do
        echo "# $line"
        eval "$line"
        echo ""
    done >/tmp/troubleshooting.txt 2>&1 <<"EOF"
date
uname -a
grep PRETTY /etc/os-release
lsusb | grep 0bda
lsmod | grep \\b88
rfkill list
mokutil --sb-state 2>/dev/null
dkms status || apt policy dkms
ip a
ls -d /lib/modules/*/build /usr/src/linux-headers-*
is_command dpkg && dpkg -S /boot /lib/modules
iw reg get
nmcli dev wifi || iwlist scanning
journalctl -b -n 5000 --file /[vr][au][rn]/log/journal/"$(cat /etc/machine-id)"/system.journal
EOF
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
        # TODO: for some reason, a delay is needed here, otherwise pkexec might not appear!
        sleep 1
        exec pkexec "$scriptpath" ${_PAUSE_ON_EXIT:+-p} "$@"
    fi

    # Tolerate users using `su` instead of `su -`
    if ! echo "$PATH" | grep -qw sbin; then
        export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    fi
    busybox_fallbacks
    detect_package_manager
    if [ "$_TROUBLESHOOT" = "1" ]; then
        troubleshoot
        die "The troubleshoot information was saved in:
    /tmp/troubleshooting.txt
Please attach that file in an email to:
    support@brostrend.com"
    fi
    detect_adapter
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
