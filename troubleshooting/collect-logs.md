---
parent: Troubleshooting
---

# Collect logs

In certain cases our support team will ask for additional troubleshooting
information so that they may pinpoint the cause of the reported issue. To
collect it, please follow these steps:

1. Reboot your computer so that we'll see only the recent, relevant system
   messages and not old ones.

2. Reproduce the issue. For example, if you can't connect to a Wi-Fi network,
   do attempt to connect even though it fails, so that the related error
   messages will appear in the logs.

3. Establish an Internet connection to be able to download and run the
   troubleshooter. For example, if our adapter doesn't work, use an Ethernet
   cable, another Wi-Fi adapter, or your phone in USB-to-WiFi tethering mode.

4. Open a terminal and copy-paste the following commands to download and run
   our troubleshooter. Type your password if prompted for it:

    ```shell
    wget linux.brostrend.com/install -O ~/troubleshooter.sh
    sh ~/troubleshooter.sh -t
    ```

5. Paste the following command to open the /tmp/troubleshooting.txt log file in
   your editor:

    ```shell
    xdg-open /tmp/troubleshooting.txt
    ```

6. Attach that log file (or its contents) to the email thread where our support
   team has asked for it. If you're concerned about confidential information
   such as IPs or MAC addresses, you may redact it before sending the log file.
   But rest assured that our support team never shares the log files with
   anyone.
