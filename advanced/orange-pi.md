---
nav_exclude: true
---

# Orange Pi support

Preliminary testing of an Orange Pi 5b device suggests the following:

## AC1L and AC3L

Our AC1L and AC3L adapters work out of the box there, as the Orange Pi Linux
kernel includes an 88x2bu driver. Do **not** run our installer in that case,
it's not needed (and it will fail). If you did run it, uninstall it using the
following command:

    sudo apt purge rtl88x2bu-dkms

## AC5L, AX1L and AX4L

Our AC5L, AX1L and AX4L adapters do not work out of the box in Orange Pi
devices using their customized Linux kernel. To compile our driver, you first
need to manually download and install the Orange Pi kernel headers.
Unfortunately they only offer them in a Google drive folder, not in an apt
repository. The download process goes like this:

-   Visit their [Downloads
    page](http://www.orangepi.org/html/serviceAndSupport/index.html)
-   Select your device
-   Select `Official Tools: Downloads`
-   Select the `Linux-kernel header files-Deb package` Google drive folder
-   In a terminal, run `dpkg-query -W linux-image-legacy*` to see your kernel
    package version. Locate the corresponding Google drive folder, for example
    v1.1.0 or v1.1.2. At the right of that folder, click the `Download` icon.
-   Unzip the file that you have downloaded, for example
    `v1.1.2-20230607T160712Z-001.zip`. Then enter that folder, open a terminal
    and run:

        sudo apt install ./*.deb

Then re-run our installer. It will fail! Then, run the following commands:

    sudo sed 's/^[[:space:]]*rlen = kernel_read/MODULE_IMPORT_NS(VFS_internal_I_am_really_a_filesystem_and_am_NOT_a_driver);\t&/' -i /usr/src/*/os_dep/osdep_service*.c
    sudo apt install -f

Then reboot and verify that our adapter works properly.
