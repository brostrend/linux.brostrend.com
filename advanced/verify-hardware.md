---
nav_exclude: true
---

# Verify hardware

In same cases USB adapters may be damaged and may stop communicating properly
with the host computer. The following procedure will help you determine this.

## lsusb procedure

1. Insert the wifi adapter directly into a USB slot. For this test, please do
   not use an extension cable nor a USB hub.

2. Open a terminal and run the following command:

    ```shell
    lsusb | grep -E '(0bda|368b|a69c):(8812|b812|c811|b832|1a2b|88df|5721)'
    ```

   This command works even if no drivers are installed, and is supposed to show
   one of the following lines, depending on the model of your adapter:

   | Model | Output of lsusb |
   | ----- | --------------- |
   | AC1L or AC3L version 1 | Bus 003 Device 005: ID **0bda:8812** Realtek Semiconductor Corp. |
   | AC1L or AC3L version 2 | Bus 003 Device 005: ID **0bda:b812** Realtek Semiconductor Corp. |
   | AC5L | Bus 003 Device 005: ID **0bda:c811** Realtek Semiconductor Corp. |
   | AX1L or AX4L wlan mode | Bus 003 Device 005: ID **0bda:b832** Realtek Semiconductor Corp. |
   | AX1L or AX4L storage mode | Bus 003 Device 005: ID **0bda:1a2b** Realtek Semiconductor Corp. |
   | AX5L wlan mode | Bus 003 Device 005: ID 0bda:**368b:88df** AICSemi AIC8800DC |
   | AX5L storage mode | Bus 003 Device 005: ID **a69c:5721** aicsemi Aic MSC |

3. If you see one of the above IDs in the output, this means that your adapter
   properly communicates with the computer. In that case, please follow our
   [troubleshooting instructions](../../troubleshooting/) and send us their
   output, to help you resolve what other issues might affect you.

4. If `lsusb` didn't produce the correct output, please test in different USB
   ports, both in front and back sides of your computer. Please also verify
   that these ports are not broken, by inserting a USB mouse or keyboard in
   them, and seeing that it works.

5. If you verified that the adapter is indeed damaged, please let us know, and
   then please return the adapter to Amazon for a replacement.

## dmesg procedure

The `lsusb` procedure above should suffice in most cases. If you want to test
more, you may also use the following procedure:

1. Remove the adapter from your PC.

2. Open a terminal and run the following command:

   ```shell
   dmesg -w
   ```

   This command will show the Linux kernel messages in real time. Ignore the
   older messages and focus on the new ones that should show up with the next
   step.

3. Insert the adapter in a USB slot. Messages like the following should show
   up. If they don't, the adapter or the USB slot are damaged:

   ```shell
   [    5.532547] usb 1-1.5: New USB device found, idVendor=0bda, idProduct=c811, bcdDevice= 2.00
   [    5.548679] usb 1-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
   [    5.563697] usb 1-1.5: Product: 802.11ac NIC
   [    5.575602] usb 1-1.5: Manufacturer: Realtek
   [    5.587469] usb 1-1.5: SerialNumber: 123456
   ```

4. If you see any messages in red color, it means they're grave errors, please
   notify us about them.

5. Try to slightly move the USB adapter. No new messages should appear. If they
   do, it means that the adapter isn't seated properly in the USB slot, and
   it's causing disconnections every time it's slightly moved.

6. If you verified that the adapter is indeed damaged, please let us know, and
   then please return the adapter to Amazon for a replacement.
