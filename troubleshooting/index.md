---
has_children: true
nav_order: 5
has_toc: false
---

# Troubleshooting

The most common issues that customers report with our adapters are shown in the
list below. If the problem was reported by our installer, try to match the last
lines in the terminal output with the examples below, to get directed to the
respective page. If none of them matches your issue, please collect and send us
the [troubleshooting information](collect-logs.md).

> 💡 **Note:** in your terminal output, the module name (e.g. 88x2bu) or kernel
> version (e.g. 6.8.0-47-generic) might be different than in the examples.

**For this sample output, see the [Secure boot](secure-boot.md) page:**

    modprobe: ERROR: could not insert '88x2bu': Key was rejected by service
    Aborting, command failed: modprobe 88x2bu

**For this sample output, see the [OS updates](os-updates.md) page:**

    modprobe: FATAL: Module 88x2bu not found in directory /lib/modules/6.8.0-47-generic
    Aborting, command failed: modprobe 88x2bu

**For this sample output, see the [Interrupted dpkg](interrupted-dpkg.md) page:**

    E: dpkg was interrupted, you must manually run ‘sudo dpkg –configure -a’ to correct the problem.

**For this sample output, see the [Unattended upgrades](unattended-upgrades.md) page:**

    E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)
    E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?
