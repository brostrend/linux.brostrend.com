---
has_children: true
nav_order: 3
has_toc: false
---

# Troubleshooting

If you encounter problems with the driver installation, the best thing to do is follow [installation step 6](https://deb.trendtechcn.com/#installation-steps) and send us all the installer output. Some common issues are also documented under the Troubleshooting menu to the left of this site, do have a quick look in case yours is one of them.

If these didn't solve the problem, please open a terminal and run the following commands to collect troubleshooting information:

```shell
nmcli dev wifi || iwlist scanning
ip a
dkms status
mokutil --sb-state
lsusb | grep 0bda
lsmod | grep \\b88
uname -a
echo /usr/src/linux-headers-*
grep PRETTY /etc/os-release
```

Then select all the output and paste it as text (not as screenshot) in an email to us. This will give us enough information to help with troubleshooting the issue.
