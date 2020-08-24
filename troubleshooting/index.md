---
has_children: true
nav_order: 3
has_toc: false
---

# Troubleshooting

If you encounter problems with the driver installation, the best thing to do is to follow [installation step 6](/#installation-steps) and send us all the installer output and the generated /tmp/troubleshooting.txt file.
Also, some common issues are documented under the Troubleshooting menu to the left of this site, do have a quick look in case yours is one of them.

If these didn't solve the problem, please do the following steps:

1. Open a terminal and copy-paste the following command to download our troubleshooting script:

    ```shell
    busybox wget deb.trendtechcn.com/install -O ~/troubleshooting.sh
    ```

2. Reboot your system to clear the system logs.

3. Reproduce the problem again.

4. At that point, open a terminal and run our troubleshooting script that you have previously downloaded:

    ```shell
    sh ~/troubleshooting.sh -t
    ```

5. This will generate a file named /tmp/troubleshooting.txt in your hard disk. Please attach it in an [email to us](mailto:support@trend-tech.net.cn), while describing the problem.
