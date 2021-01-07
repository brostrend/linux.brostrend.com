---
parent: Troubleshooting
---

# Secure boot

Newer computer systems with [UEFI firmware](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) sometimes have [secure boot](https://wiki.ubuntu.com/UEFI/SecureBoot) enabled that prohibits code to be loaded if it’s not signed by Microsoft. To bypass that, Linux distributions have a pre-loader called [shim](https://wiki.ubuntu.com/UEFI/SecureBoot/ShimUpdateProcess) that gets signed by Microsoft, and which in turn can load code signed by the distribution, such as Canonical or Debian kernels and kernel modules.

This means that to compile and load third-party drivers like ours (or Nvidia's), that are not signed by the Linux distributions, you would need to:

- [Disable secure boot](#disable-secure-boot), which is the easiest solution, or
- [Create you own driver signing key](#create-your-own-driver-signing-key) and sign the third-party drivers with it

But before starting to execute one of these methods, let’s make sure that you have secure boot enabled. Open a terminal and run this command:

```shell
sudo mokutil --sb-state
```

If it reports “SecureBoot enabled”, continue reading. If it reports “SecureBoot disabled”, please stop and email us, as your issue likely isn’t related to secure boot.

## Disable secure boot

If you choose to disable secure boot, you need to enter the UEFI (BIOS) settings by pressing Del or some other key when your computer boots. For more information, see [this askubuntu question](https://askubuntu.com/questions/891248/ubuntu-16-04-how-can-i-disable-secure-boot). After you disable secure boot, you might need to run our installer again for the driver to load.

If you disable secure boot, you don't need to read the rest of this document.

## Create your own driver signing key

When you run our installer, and your Linux distribution detects that the user tries to install a third-party driver while secure boot is enabled, it shows a series of dialogs. You're supposed to go through them, enter a "signing key password", and then reboot and enter that password once more while the computer boots! It is a bit complicated, that's why we suggest the "Disable secure boot" method instead. If you saw the following dialogs but you closed them by mistake, run our installer again so that they show up once more.

This is the initial dialog that documents secure boot. Press the Enter key to continue:

<div style="background-color: #d3d7cf; color: #333333; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌────────────────────────┤ <span style="color: #cc0000">Configuring Secure Boot</span> ├───────────────────────┐
│                                                                          │
│ Your system has UEFI Secure Boot enabled.                                │
│                                                                          │
│ UEFI Secure Boot requires additional configuration to work with          │
│ third-party drivers.                                                     │
│                                                                          │
│ The system will assist you in configuring UEFI Secure Boot. To permit    │
│ the use of third-party drivers, a new Machine-Owner Key (MOK) has been   │
│ generated. This key now needs to be enrolled in your system's firmware.  │
│                                                                          │
│ To ensure that this change is being made by you as an authorized user,   │
│ and not by an attacker, you must choose a password now and then confirm  │
│ the change after reboot using the same password, in both the "Enroll     │
│ MOK" and "Change Secure Boot state" menus that will be presented to you  │
│ when this system reboots.                                                │
│                                                                          │
│ If you proceed but do not confirm the password upon reboot, Ubuntu will  │
│ still be able to boot on your system but any hardware that requires      │
│ third-party drivers to work correctly may not be usable.                 │
│                                                                          │
│                                  <span style="background-color: #cc0000; color: #d3d7cf">&lt;Ok&gt;</span>                                    │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

In the next dialog you define a password:

<div style="background-color: #d3d7cf; color: #333333; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌────────────────────────┤ <span style="color: #cc0000">Configuring Secure Boot</span> ├───────────────────────┐
│                                                                          │
│                                                                          │
│ Enter a password for Secure Boot. It will be asked again after a reboot. │
│                                                                          │
│ <span style="background-color: #75507b">________________________________________________________________________</span> │
│                                                                          │
│                    &lt;Ok&gt;                        &lt;Cancel&gt;                  │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

Enter the password again:

<div style="background-color: #d3d7cf; color: #333333; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌────────────────────────┤ <span style="color: #cc0000">Configuring Secure Boot</span> ├───────────────────────┐
│                                                                          │
│                                                                          │
│ Enter the same password again to verify you have typed it correctly.     │
│                                                                          │
│ <span style="background-color: #75507b">________________________________________________________________________</span> │
│                                                                          │
│                    &lt;Ok&gt;                        &lt;Cancel&gt;                  │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

At that point the driver installation finishes with the following error message, as the system doesn't yet trust the signing key that you just created:

```shell
modprobe: ERROR: could not insert '88x2bu': Operation not permitted
```

Now you're supposed to reboot your computer. Very early in the boot process, and right before the grub boot manager shows up, you'll see the following dialog. Select "Enroll MOK" and press Enter:

<div style="background-color: #1030ff; color: #e0e0e0; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌──────────────────────────────────────────────────────────────────────────┐
│                          Perform MOK management                          │
│                                                                          │
│                        ┌───────────────────────┐                         │
│                        │     Continue boot     │                         │
│                        │<span style="background-color: #1e1e1e">      Enroll MOK       </span>│                         │
│                        │ Enroll key from disk  │                         │
│                        │ Enroll hash from disk │                         │
│                        └───────────────────────┘                         │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

Select Continue:

<div style="background-color: #1030ff; color: #e0e0e0; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌──────────────────────────────────────────────────────────────────────────┐
│                                Enroll MOK                                │
│                                                                          │
│                              ┌────────────┐                              │
│                              │ View key 0 │                              │
│                              │<span style="background-color: #1e1e1e">  Continue  </span>│                              │
│                              └────────────┘                              │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

Select Yes:

<div style="background-color: #1030ff; color: #e0e0e0; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌──────────────────────────────────────────────────────────────────────────┐
│                             Enroll the keys?                             │
│                                                                          │
│                                 ┌─────┐                                  │
│                                 │ No  │                                  │
│                                 │<span style="background-color: #1e1e1e"> Yes </span>│                                  │
│                                 └─────┘                                  │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

Enter the same password as in the initial dialogs:

<div style="background-color: #1030ff; color: #e0e0e0; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌──────────────────────────────────────────────────────────────────────────┐
│                             Enroll the keys?                             │
│                                                                          │
│                        ┌────────────────────────┐                        │
│                        │ Password:              │                        │
│                        └────────────────────────┘                        │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

Select reboot:

<div style="background-color: #1030ff; color: #e0e0e0; font-size: 0.85em;
display: inline-block; padding: 0.5em; border-radius: 0.5em">
<pre style="margin: 0; line-height: normal">
┌──────────────────────────────────────────────────────────────────────────┐
│                          Perform MOK management                          │
│                                                                          │
│                        ┌───────────────────────┐                         │
│                        │<span style="background-color: #1e1e1e">        Reboot         </span>│                         │
│                        │ Enroll key from disk  │                         │
│                        │ Enroll hash from disk │                         │
│                        └───────────────────────┘                         │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
</pre></div>

The procedure is now completed. The shim pre-loader enrolled your self-generated driver signing key into your UEFI settings, so now our driver will be loaded without "Operation not permitted" errors.
