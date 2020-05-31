---
has_children: true
nav_order: 3
has_toc: false
---

# Troubleshooting

If you encounter problems with the driver installation, the best thing to do is to follow [installation step 6](https://deb.trendtechcn.com/#installation-steps) and send us all the installer output and the generated /tmp/troubleshooting.txt file.
Also, some common issues are documented under the Troubleshooting menu to the left of this site, do have a quick look in case yours is one of them.

If these didn't solve the problem, please establish again an Internet connection, open a terminal or press Alt+F2 to invoke your distribution's "Execute command" dialog, and paste the following command:

```shell
sh -c 'busybox wget deb.trendtechcn.com/install -O /tmp/install && sh /tmp/install -t'
```

This is the same as the installation command, except it has a `-t` in the end, to invoke the troubleshooter.
Then send us the generated /tmp/troubleshooting.txt file in a mail to [support@trend-tech.net.cn](mailto:support@trend-tech.net.cn), while also describing the problem.
