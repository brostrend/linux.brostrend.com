#!/bin/sh
# analyze_offline.sh (revised for Jetson/modified uname)
# Part 1: Analyze system and determine required files for offline installation.
# Run this script on the target machine (no internet needed).

# --- Minimal necessary functions ---

usage() {
    printf "Usage: %s [OPTIONS]

Analyzes the system to determine files needed for offline driver installation.
Outputs a list of required package names and the driver URL.
NOTE: Kernel header detection is adapted for systems where 'uname -r' might not match package names (like Jetson L4T).

Options:
    -h  Show this help message.
" "$0"
}

bold() {
    # ... (same as before) ...
    if [ "$_PRINTBOLD_FIRST_TIME" != 1 ]; then
        _PRINTBOLD_FIRST_TIME=1
        _BOLD_FACE=$(tput bold 2>/dev/null) || true
        _NORMAL_FACE=$(tput sgr0 2>/dev/null) || true
    fi
    if [ "$1" = "-n" ]; then
        shift
        printf "%s" "${_BOLD_FACE}$*${_NORMAL_FACE}" >&2
    else
        printf "%s\n" "${_BOLD_FACE}$*${_NORMAL_FACE}" >&2
    fi
}

# Check if parameter is a command
is_command() {
    command -v "$1" >/dev/null 2>&1
}

# Implement lsusb
lsusb_() {
    # ... (same as before) ...
    local fname fdir usbid msg

    for fname in /sys/bus/usb/devices/*/idVendor; do
        fdir=${fname%/*}
        if [ -r "$fname" ] && [ -r "$fdir/idProduct" ]; then
            usbid="$(cat "$fname"):$(cat "$fdir/idProduct")"
            case "$usbid" in
            0bda:8812) msg="Brostrend AC1Lv1/AC3Lv1 Wi-Fi adapter" ;;
            0bda:b812) msg="Brostrend AC1L/AC3L Wi-Fi adapter" ;;
            0bda:c811) msg="Brostrend AC5L Wi-Fi adapter" ;;
            0bda:1a2b) msg="Brostrend AX1L/AX4L Wi-Fi adapter (storage mode)" ;;
            0bda:b832) msg="Brostrend AX1L/AX4L Wi-Fi adapter" ;;
            a69c:5721) msg="Brostrend AX5L Wi-Fi adapter (storage mode)" ;;
            368b:88df) msg="Brostrend AX5L Wi-Fi adapter" ;;
            *) continue ;;
            esac
            echo "$usbid $msg"
        fi
    done
}

# Set _DRIVER
select_driver() {
    # ... (same as before) ...
    local fname product _dummy choice

    fname=${0##*/}
    fname=${fname%.sh}
    case "$fname" in
     8812au | 88x2bu | 8821cu | 8852bu) _DRIVER="rtl$fname" ;;
     aic8800) _DRIVER=$fname ;;
    esac

    while [ -z "$_DRIVER" ]; do
        while read -r product _dummy; do
            case "$product" in
            0bda:8812) _DRIVER=rtl8812au ;;
            0bda:b812) _DRIVER=rtl88x2bu ;;
            0bda:c811) _DRIVER=rtl8821cu ;;
            0bda:1a2b) _DRIVER=rtl8852bu ;;
            0bda:b832) _DRIVER=rtl8852bu ;;
            a69c:5721) _DRIVER=aic8800 ;;
            368b:88df) _DRIVER=aic8800 ;;
            esac
        done <<EOF
$(lsusb_)
EOF
        test -n "$_DRIVER" && break
        bold "Could not detect the adapter!"
        echo "Please insert the BrosTrend Wi-Fi adapter into a USB slot..." >&2
        # ... (rest of prompt same as before) ...
        bold -n "Please type your choice, or [Enter] to re-detect: "
        read -r choice
        case "$choice" in
        a) _DRIVER=rtl8812au ;;
        b) _DRIVER=rtl88x2bu ;;
        c) _DRIVER=rtl8821cu ;;
        d) _DRIVER=rtl8852bu ;;
        e) _DRIVER=aic8800 ;;
        q) echo "Aborted by user." >&2 ; exit 1 ;;
        *) continue ;;
        esac
    done
    echo "DRIVER=$_DRIVER"
}

detect_package_manager() {
    # ... (same as before) ...
    for _PM in apt-get dnf eopkg pacman pkgtool ppm swupd yum xbps-install zypper unknown; do
        if is_command "$_PM"; then
            if [ "$_PM" = "apt-get" ] && ! is_command dpkg && is_command rpm; then
                 _PM=apt-rpm
            fi
            break
        fi
    done
    echo "PM=$_PM"
}

# Output a message to stderr and abort execution
die() {
    bold "$@" >&2
    exit 1
}

# --- NEW: Helper to check for installed headers ---
check_headers_installed() {
    local kdir build_link source_link found=0
    bold "Checking for existing kernel headers..."
    if [ -d /lib/modules ]; then
        for kdir in /lib/modules/*; do
             if [ -e "$kdir/build" ]; then
                 build_link=$(readlink -f "$kdir/build" 2>/dev/null || echo "$kdir/build")
                 if [ -d "$build_link" ] && [ -f "$build_link/Makefile" ]; then
                     bold "Found potential headers linked at: $kdir/build -> $build_link"
                     found=1
                     break # Found one, assume it's for the running kernel
                 fi
             fi
             if [ -e "$kdir/source" ]; then
                 source_link=$(readlink -f "$kdir/source" 2>/dev/null || echo "$kdir/source")
                  if [ -d "$source_link" ] && [ -f "$source_link/Makefile" ]; then
                     bold "Found potential headers linked at: $kdir/source -> $source_link"
                     found=1
                     break # Found one, assume it's for the running kernel
                 fi
             fi
        done
    fi
    # Also check common /usr/src location
    if [ "$found" -eq 0 ] && [ -d /usr/src ]; then
        for kdir in /usr/src/linux-headers-*; do
            if [ -d "$kdir" ] && [ -f "$kdir/Makefile" ]; then
                bold "Found potential headers installed at: $kdir"
                found=1
                break # Found one, assume it's usable
            fi
        done
    fi

    if [ "$found" -eq 1 ]; then
        _HEADERS_FOUND=1
        bold "Kernel headers seem to be installed."
    else
        _HEADERS_FOUND=0
        bold "Kernel headers not found in standard locations (/lib/modules/*/build, /usr/src/linux-headers-*)."
    fi
}


# List required prerequisites based on package manager (Revised for headers)
list_prerequisites() {
    local pkgs_list=""

    # Common tools needed for compilation/dkms
    pkgs_list="bc make tar"
    # Need 'ar' (usually from binutils) and 'gcc' if dkms isn't available/used
    pkgs_list="$pkgs_list binutils gcc"
    # dkms is preferred
    pkgs_list="$pkgs_list dkms"

    bold "Analyzing prerequisites for Package Manager: $_PM"
    case "$_PM" in
    apt-get | apt-rpm)
        # Debian/Ubuntu specific dependencies
        pkgs_list="$pkgs_list libc6-dev linux-libc-dev"

        # Check if headers are already installed
        check_headers_installed # Sets _HEADERS_FOUND

        if [ "$_HEADERS_FOUND" -eq 0 ]; then
            bold "Listing potential kernel header packages for Debian/Ubuntu based systems."
            bold "--- IMPORTANT ---"
            bold "Since 'uname -r' might not match package names on this system (e.g., Jetson L4T),"
            bold "you MUST verify the CORRECT kernel header package name for your specific OS version/hardware."
            bold "Common names for Jetson L4T include 'nvidia-l4t-kernel-headers' or using the SDK Manager/JetPack."
            bold "Consult your system documentation."
            bold "-----------------"
            # Add common possibilities to the list for the user to verify/select during download
            pkgs_list="$pkgs_list linux-headers-generic" # Standard Ubuntu fallback
            pkgs_list="$pkgs_list nvidia-l4t-kernel-headers" # Common Jetson package name
            # Add other potential names if known for specific L4T versions if desired
        fi
        ;;
    dnf | yum | zypper)
        pkgs_list="$pkgs_list elfutils-libelf-devel" # Needed for RPM distros
        check_headers_installed
        if [ "$_HEADERS_FOUND" -eq 0 ]; then
             bold "Listing potential kernel header packages for RPM based systems."
             bold "--- IMPORTANT ---"
             bold "Please verify the correct kernel development package (e.g., kernel-devel, kernel-default-devel) for your system."
             bold "-----------------"
             pkgs_list="$pkgs_list kernel-devel" # Generic fallback
             pkgs_list="$pkgs_list kernel-default-devel" # openSUSE fallback
        fi
        # Assume dkms exists if PM is dnf/yum/zypper for listing purposes
        ;;
     eopkg|pacman|swupd|xbps-install)
         # These package managers often handle kernel headers dependencies better via dkms or standard names
         check_headers_installed
         if [ "$_HEADERS_FOUND" -eq 0 ]; then
             bold "Listing standard header package names. Verify correctness for your system."
             case "$_PM" in
                 eopkg) pkgs_list="$pkgs_list linux-current-headers" ;;
                 pacman) pkgs_list="$pkgs_list linux-headers" ;;
                 swupd) pkgs_list="$pkgs_list kernel-native-dkms" ;; # Example, might need 'lts' etc.
                 xbps-install) pkgs_list="$pkgs_list $(xbps-query -R linux-headers | head -n1 | cut -d ' ' -f 1 || echo linux-headers)" ;; # Attempt to find installed one
             esac
         fi
        ;;
    *)
        bold "Unsupported package manager '$_PM'. Listing generic dependencies."
        check_headers_installed
         if [ "$_HEADERS_FOUND" -eq 0 ]; then
            bold "--- IMPORTANT ---"
            bold "Kernel headers package name cannot be determined automatically."
            bold "Please identify and manually add the correct header package for your system."
            bold "-----------------"
            pkgs_list="$pkgs_list linux-headers" # Very generic guess
        fi
        ;;
    esac

    # Output packages, one per line, prefixed with PKG:
    echo "$pkgs_list" | tr ' ' '\n' | grep -v '^$' | sed 's/^/PKG:/'

    # Add the driver URL, prefixed with URL:
    echo "URL:https://linux.brostrend.com/${_DRIVER}-dkms.deb"
}

# --- Main Analysis Logic ---
main() {
    local running_kernel

    if [ "$1" = "-h" ]; then
        usage
        exit 0
    fi

    bold "Starting Offline Analysis (uname-independent header check)..."
    # Get uname -r for informational purposes only
    running_kernel=$(uname -r 2>/dev/null || echo "unknown")
    echo "INFO: Kernel reported by 'uname -r': $running_kernel (May not match package names)"


    select_driver # Sets _DRIVER and prints it
    detect_package_manager # Sets _PM and prints it
    list_prerequisites # Prints PKG: lines and URL: line based on PM and header checks

    bold "Analysis complete."
    bold "Review the PKG: list above carefully, especially the kernel headers package(s)."
    bold "Ensure you download the correct one for your specific system (e.g., Jetson L4T version) if headers are not already installed."
    bold "Use the full output (DRIVER=, PM=, PKG:, URL:) with the download script on an internet-connected machine."
}

# --- Script Execution ---
main "$@"