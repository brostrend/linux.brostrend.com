---
nav_order: 3
---

# Troubleshooting

If you encounter problems with the driver installation, please open a terminal and run the following commands:

```shell
ip a
dkms status
lsusb | grep 0bda
lsmod | grep \\b88
uname -a
echo /usr/src/linux-headers-*
grep PRETTY /etc/os-release
```

Then select all the output and paste it as text (not as screenshot) in an email to us. This will give us enough information to help with troubleshooting the issue.
