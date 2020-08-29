---
parent: Troubleshooting
---

# Kernel version

Our wifi adapter chipsets and drivers are developed by Realtek. We prefer to package their official drivers rather than rely on unofficial drivers found on github.

Unfortunately Realtek doesn't support the latest kernels that rolling distributions like Kali use. We do make sure that the latest official Ubuntu and Debian stable kernels are supported though, and we do state which kernels we support in our Amazon product page.

As an example, in April 2020, Ubuntu 20.04 shipped with the 5.4 kernel, and our driver supported it. At the same time, Kali rolling started using the 5.6 kernel, so our driver didn't work there. Two months later, Realtek released a new driver that supported kernels up to 5.7, so for these two months Kali users were unable to use the official Realtek driver.

One solution to this problem is to downgrade the kernel to a supported version. Most distributions include documentation on how this can be done. Another solution is to return our adapter for a refund, as it's covered by a two-year warranty.

Finally, it's possible to completely ignore our driver, and use other drivers found online on github. We cannot support these, but we do know that they frequently include unofficial patches that make the Realtek drivers work in more recent kernels, usually for Kali Linux users. Start by uninstalling our driver with `sudo apt-get purge "^rtl88.*u-dkms$"`, then use the following links to find the most famous drivers, and follow their installation instructions from their sites.

* Old version 1 of AC1L and AC3L, google for: [8812au github](https://www.google.gr/search?q=8812au+github)
* New version 2 of AC1L and AC3L, google for: [88x2bu github](https://www.google.gr/search?q=88x2bu+github)
* AC5L, google for: [8821cu github](https://www.google.gr/search?q=8821cu+github)
