---
parent: Troubleshooting
---

# Interrupted dpkg

While running our installer, the following error might show up:

> E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.

This isn't a issue with our installer; it will also appear if you try to install any other program. It means that at some point, package installation in your system was forcibly interrupted.

One reason why this might have happened, is that Debian and Ubuntu usually have automatic updates enabled in the background, so users might reboot their PCs without realizing that they're interrupting an installation procedure. Another reason is on Raspberries; the Pi CPU, especially on Pi Zero, is extremely slow, so our installer might appear to hang, while it's actually compiling and it might need up to an hour to finish.

To fix the broken system, just do what the message says. Open a terminal, and run:

```shell
sudo dpkg --configure  -a
```

Wait until it finishes, no matter how long it takes. Then rerun our installer, it should then work fine.
