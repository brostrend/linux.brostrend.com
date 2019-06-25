#!/bin/sh
# Copyright (C) 2018 Alkis Georgopoulos <alkisg@gmail.com>
# License GNU GPL version 3 or newer <http://gnu.org/licenses/gpl.html>

usage() {
    cat <<EOF
Usage: $0 [OPTIONS] [COMMAND]

Install the drivers for the BrosTrend AC1/AC3 adapters.
The main difficulty is in detecting the appropriate kernel *headers* package.

Options:
    -h  Show this help message.
    -p  Pause on exit.
EOF
}

bold() {
    if [ -z "$printbold_first_time" ]; then
        printbold_first_time=true
        bold_face=$(tput bold 2>/dev/null) || true
        normal_face=$(tput sgr0 2>/dev/null) || true
    fi
    printf "%s\n" "${bold_face}$*${normal_face}"
}

log() {
    logger -t rtl88x2bu-dkms -p syslog.err "$@"
}

# Output a message to stderr and abort execution
die() {
    log "$@"
    bold "$@" >&2
    pause_exit 1
}

pause_exit() {
    local dummy

    if [ "$PAUSE_ON_EXIT" = true ]; then
        read -p "Press [Enter] to close the current window." dummy
    fi
    exit "$@"
}

install_kernel_headers() {
    local kernel header headers

    # If the appropriate headers are already installed, return
    test -f "/usr/src/linux-headers-$(uname -r)/Makefile" && return 0

    # We assume that the linux-image package name doesn't contain a dot.
    # Possible names:
    # Ubuntu: https://packages.ubuntu.com/source/bionic/linux-meta
    # E.g. linux-image-generic, linux-image-lowlatency-hwe-16.04
    # Debian: https://packages.debian.org/source/stretch/linux-latest
    # E.g. linux-image-686, linux-image-amd64, linux-image-armmp
    # Raspbian: raspberrypi-kernel
    headers=""
    for kernel in $(dpkg -l 'linux-image*' raspberrypi-kernel 2>/dev/null |
        awk '/^ii/ { print $2 }' | fgrep -v .)
    do
        case "$kernel" in
            raspberrypi-kernel)
                header=raspberrypi-kernel-headers ;;
            *)
                header=$(echo "$kernel" | sed 's/image/headers/') ;;
        esac
        if apt-cache policy "$header" | grep -q '[0-9]'; then
            headers="$headers $header"
        fi
    done
    if [ -n "$headers" ]; then
        bold "Installing kernel headers:$headers"
        apt-get install --yes $headers || die "Couldn't install kernel headers"
    else
        die "Couldn't detect the appropriate kernel headers package!"
    fi
}

main() {
    case "$1" in
        '') ;;
        -p) PAUSE_ON_EXIT=true ;;
        *)  usage; exit 0 ;;
    esac

    # First check if we need to spawn an x-terminal-emulator.
    # Note that after pkexec we don't have access to $DISPLAY.
    if [ "$PAUSE_ON_EXIT" != true ] && { [ ! -t 0 ] || [ ! -t 1 ] ;} &&
        xmodmap -n >/dev/null 2>&1
    then
        title=${1##*/}
        case "$title" in
            -s|--source) title=${2##*/} ;;
            '') title=${0##*/} ;;
        esac
        PAUSE_ON_EXIT=true exec x-terminal-emulator -T "$title" -e sh "$0" "$@"
    fi

    # Get root access if we don't already have it
    if [ $(id -u) -ne 0 ]; then
        # Make the installer executable, in case it was downloaded from the web.
        scriptpath="$(cd "$(dirname "$0")" ; pwd -P)/$(basename "$0")"
        test -x "$scriptpath" || chmod +x "$scriptpath"
        test -x "$scriptpath" || die "Could not make $scriptpath executable"

        bold "Root access is required in order to install the driver"
        # TODO: for some reason, a delay is needed here, otherwise pkexec might not appear!
        sleep 1
        exec pkexec "$scriptpath" ${PAUSE_ON_EXIT:+-p} "$@"
    fi

    bold "Updating your apt sources"
    apt-get update || bold 'Continuing even though `apt-get update` reported failure!'

    install_kernel_headers

    bold "Downloading the driver"
    cd $(mktemp -d)
    wget https://deb.trendtechcn.com/rtl88x2bu-dkms.deb || die "Couldn't download the driver"

    bold "Installing and compiling the driver"
    # Prefer apt, but fall back to dpkg if necessary
    if dpkg --compare-versions $(dpkg-query -W apt | awk '{ print $2 }') gt 1.2; then
        # We want --no-install-recommends here because dkms in Debian recommends
        # a lot of kernel header packages that we may not require.
        # Caution, linuxmint uses an apt wrapper that can run `apt install --yes`
        # but it doesn't understand `apt --yes install`. Meh.
        apt install --yes --reinstall --no-install-recommends ./rtl88x2bu-dkms.deb
    else
        # The downside of using dpkg instead of apt is that dkms etc
        # will be marked as "manually installed".
        apt-get install --yes --no-install-recommends dkms linux-libc-dev libc6-dev &&
        dpkg -i ./rtl88x2bu-dkms.deb
    fi

    ret=$?
    printf "\n"
    if [ $ret -eq 0 ]; then
        bold "
========================================
 The driver was successfully installed!
========================================"
    else
        bold "System information:"
        uname -a
        grep PRETTY /etc/os-release
        ls /lib/modules
        dpkg -l "*$(uname -r)*" | grep "$(uname -r)"
        dkms status
        bold "
===================================================
 ERROR: The driver was NOT successfully installed!
===================================================
Please select all the text in this terminal, then right click with the
mouse and select Copy, and finally paste all the text in an email to:
    support@trend-tech.net.cn"
    fi
    pause_exit $ret
}

main "$@"
