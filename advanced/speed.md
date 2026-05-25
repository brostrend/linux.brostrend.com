---
nav_exclude: true
---

# Speed optimization

This page contains advice on how to optimize the Wi-Fi speeds you're able to
reach with our Wi-Fi adapters. See also our [speedtest page](speedtest.md) for
the maximum possible speed of each adapter model.

> 💡 **Note:** If you contact us for assistance regarding speed optimization,
> we'd appreciated it if you follow all the instructions in this page, and send
> us your findings along with the output of all the commands in this page.
> Additionally, please also collect and send us the
> [troubleshooting logs](../troubleshooting/collect-logs.md).

## Placement

Before troubleshooting anything else, it's very important to place your access
point and the Wi-Fi adapter optimally. You should do that even if you don't
plan to keep them in these temporary places, as for example if the signal is
being reflected from a nearby wall, it may cause the speed to drop tenfold,
making the rest of your tests unreliable.

- Temporarily move the adapter and your access point very close to each other
  (e.g. 1m), with nothing between them. This will ensure their signal will be
  much stronger than signals coming from reflections, or from a neighbor's
  access point.
- Place your access point and your adaper at least 50cm away from walls.
- Try to elevate both of them away from the desk or the floor, to eliminate
  reflections from these surfaces as well. In our [speed tests](speedtest.md)
  we're placing them on top of paper boxes.
- If you have a USB3 extension cable, connect the Wi-Fi adapter with that, in
  order to avoid reflections from the PC case. The AC3L and AX4L adapters have
  their own extension cable.
- If you don't have a USB3 extension cable, it's important to do speed tests
  with various USB ports, either at the back or the front of your PC, and to
  try to rotate the PC so that the adapter faces the access point.

## Signal, channel and band

Now that you've placed your devices optimally, let's ensure they have a good
signal. Open a terminal and run:

```shell
$ nmcli device wifi list
IN-USE  BSSID              SSID         MODE   CHAN  RATE         SIGNAL  BARS  SECURITY
*       0C:67:14:97:DE:30  mywifi-2g    Infra  6     270 Mbit/s   98      ▂▄▆█  WPA2 WPA3
        0C:67:14:97:DE:34  mywifi-5g    Infra  36    540 Mbit/s   92      ▂▄▆█  WPA2 WPA3
        A0:EC:80:9E:05:28  neighbor-2g  Infra  6     135 Mbit/s   74      ▂▄▆_  WPA1
        A0:EC:80:9E:05:29  neighbor-5g  Infra  52    1170 Mbit/s  55      ▂▄__  WPA1 WPA2
```

Let's interpret the output of that command:

- The asterisk (*) shows which network I'm connected to, in this case mywifi-2g.
- The CHAN shows which [Wi-Fi
  channel](https://en.wikipedia.org/wiki/List_of_WLAN_channels) my access point
  is using. Channels 1-14 are from the [slow 2.4GHz
  band](https://en.wikipedia.org/wiki/List_of_WLAN_channels#2.4_GHz_(802.11b/g/n/ax/be/bn)),
  and channels 32-177 are from the [fast 5GHz
  band](https://en.wikipedia.org/wiki/List_of_WLAN_channels#5_GHz_(802.11a/h/n/ac/ax/be/bn)).
  The even [faster 6GHz
  band](https://en.wikipedia.org/wiki/List_of_WLAN_channels#6_GHz_(802.11ax/be/bn))
  is using channel numbers 1-233, but they're in different frequencies.  
  The channel in use should be different than that of nearby access points that
  have strong signal strength.
- The SIGNAL and BARS show the signal strength. They should be close to 100 for
  the speed test, and the neighbor's signal strength should be much less, to
  avoid interference.
- The RATE shows the maximum theoretical speed that this channel can handle. It
  depends on the band and the channel width.

Knowning all this, let's try to pinpoint what's wrong in this example output:

- We're using the slow 2.4 GHz band instead of the much faster 5 GHz band.
- We're using the same channel 6 as the neighbor. The signal strength
  difference is 98-74=24, so it might be OK in this case, but if another
  channel is completely empty, we should try to switch to that. Note that in
  the 2.4GHz band, you should probably be using channels 1, 6 or 11 only, as
  nearby channels have [overlapping
  frequencies](https://en.wikipedia.org/wiki/List_of_WLAN_channels#2.4_GHz_(802.11b/g/n/ax/be/bn)).

## Channel width

A parameter called `channel width` can be configured in your access point to
allow lower or higher speeds. So for example, if you're getting only 200 Mbps
in a 40 MHz channel of the 5GHz band, it might be possible to get 400 Mbps if
you configure your router to use an 80 MHz channel width.

To view the channel widths of the available access points, run the following
commands:

```shell
# Become root
$ sudo -i

# Install the iw utility if you don't have it already
$ apt install iw

# See the name of your Wi-Fi adapter and the current channel width
$ iw dev
phy#4
        Interface wlxc83a35b022cd
                ifindex 13
                wdev 0x400000001
                addr c8:3a:35:b0:22:cd
                ssid mywifi-5g
                type managed
                channel 36 (5180 MHz), width: 80 MHz, center1: 5210 MHz
                txpower 12.00 dBm

# Scan for more access points, to see their channel widths
$ iw dev wlxc83a35b022cd scan
  # ... you'll see things like:
  * STA channel width: 20 MHz
  * channel width: 1 (80 MHz)
  ...
```

## USB 3 mode

USB2 connectivity is limited to about 300 Mbps. The AC1L, AC3L, AX1L, AX4L,
AX8L, AX9L adapters support USB3 connectivity, with much higher speeds. If you
have one of them, you should connect it to a USB3 (blue) port in your PC. To
check if it's using USB3 mode, run:

```shell
$ lsusb -tv
...
/:  Bus 002.Port 001: Dev 001, Class=root_hub, Driver=xhci_hcd/10p, 10000M
    ID 1d6b:0003 Linux Foundation 3.0 root hub
    |__ Port 007: Dev 003, If 0, Class=Vendor Specific Class, Driver=rtl8852bu, 5000M
        ID 0bda:b832 Realtek Semiconductor Corp.

```

In the lsusb command output, locate the lines that mention our adapter, e.g.
Realtek, AICSemi or Mediatek. The Driver=rtl8852bu part should match one of the
driver names that are listed in [this page](../supported-distributions.md).
Right next to it is the important part. If it says 5000M, it's in USB3 mode. If
it says 480M, it's in USB2 mode. In that case, follow the
[USB 3 mode page instructions](usb3.md).
