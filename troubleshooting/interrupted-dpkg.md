---
parent: Troubleshooting
---

# Interrupted dpkg

While running our installer, the following error might show up:

> E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.

This isn't a issue with our installer; it will also appear if you try to install any other program. It means that at some point, package installation in your system was forcibly interrupted.

Some of the reasons why this might have happened are:

- Debian and Ubuntu have [unattended upgrades](https://manpages.ubuntu.com/unattended-upgrade) enabled in the background by default, so users might reboot their PCs without realizing that they're interrupting an installation procedure.
- Some users interrupt the [secure boot configuration dialogs](../secure-boot/) by mistake.
- Older Raspberry Pi CPUs are extremely slow and may need up to an hour to compile our driver, instead of a few seconds; some users think it's hanged and interrupt the compilation.

To fix the broken system, just do what the message says. Open a terminal, and run:

```shell
sudo dpkg --configure  -a
```

Wait until it finishes, no matter how long it takes. **If you see any errors**, please forward the whole terminal output to us. If there were no errors, just rerun our installer, it should then work fine.
