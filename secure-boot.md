---
nav_order: 2
---

# Secure boot

Newer computer systems with [UEFI firmware](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) sometimes have [secure boot](https://wiki.ubuntu.com/UEFI/SecureBoot) enabled that prohibits code to be loaded if it’s not signed by Microsoft. To bypass that, Linux distributions have a pre-loader called [shim](https://wiki.ubuntu.com/UEFI/SecureBoot/ShimUpdateProcess) that gets signed by Microsoft, and which in turn can load code signed by the distribution, such as Canonical or Debian kernels and kernel modules.

This means that to compile and load external modules like our wifi drivers, that are not signed by the Linux distributions, you would need to:

- Disable secure boot, or
- Create you own signing key and sign the external drivers with it

But before starting to execute one of these methods, let’s make sure that you have secure boot enabled. Open a terminal and run this command:

```shell
sudo mokutil --sb-state
```

If it reports “SecureBoot enabled”, continue reading. If it reports “SecureBoot disabled”, please stop and email us, as your issue like isn’t related to secure boot.

## Disable secure boot

If you choose to disable secure boot, you need to enter the UEFI (BIOS) settings by pressing Del or some similar key when your computer boots. For more information, see [this askubuntu question](https://askubuntu.com/questions/891248/ubuntu-16-04-how-can-i-disable-secure-boot). After you disable secure boot, you might need to run our installer again for the driver to load.

## Create DKMS signing key

By default, when Ubuntu detects that the user tries to install an external driver while secure boot is enabled, it shows the following messages:

> Configuring Secure Boot
>
> Your system has UEFI Secure Boot enabled. UEFI Secure Boot requires additional configuration to work with third-party drivers. The system will assist you in configuring UEFI Secure Boot. To permit the use of third-party drivers, a new Machine-Owner Key (MOK) has been generated. This key now needs to be enrolled in your system's firmware. To ensure that this change is being made by you as an authorized user, and not by an attacker, you must choose a password now and then confirm the change after reboot using the same password, in both the Enroll MOK and Change Secure Boot state menus that will be presented to you when this system reboots. If you proceed but do not confirm the password upon reboot, Ubuntu will still be able to boot on your system but any hardware that requires third-party drivers to work correctly may not be usable.
>
> Enter a password for Secure Boot. It will be asked again after a reboot.
>
> \> \*\*\*\*\*\*\*\*
>
> Enter the same password again to verify you have typed it correctly.
>
> \> \*\*\*\*\*\*\*\*

After you enter the password there, you’re supposed to reboot, where you’ll see an UEFI dialog that prompts you to trust your new key. After you trust it, run our installer again and it should work fine.

You can find screenshots of this procedure in the Ubuntu [SecureBoot documentation page](https://wiki.ubuntu.com/UEFI/SecureBoot/DKMS).
