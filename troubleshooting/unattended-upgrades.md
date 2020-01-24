---
parent: Troubleshooting
---

# Unattended upgrades

While running our installer, the following error might show up:

> E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)<br />
> E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?

This isn't a issue with our installer; it will also appear if you try to install any other program. It means that at that point your operating system is installing updates, and you're trying to install our driver in parallel, which isn't allowed.

This usually happens because of the [unattended upgrades](https://wiki.debian.org/UnattendedUpgrades) Debian/Ubuntu package, which checks for updates when you boot your PC, and installs them in the background. The solution is to just wait until they're finished, then re-run our installer again. To see when they're finished, run the `top` command in a terminal or invoke the process monitoring application from the menus, and check when `apt` and `dpkg` are no longer running.

Another reason why this might happen is if you have a software center window open, like Synaptic or Gnome Software, which prevent other installations from happenning. In that case, just close the software center and try again.
