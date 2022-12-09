---
nav_exclude: true
---

# Speed test

A speed test was conducted, with the following results in Mbps:

| Adapter | Mode        | Download | Upload  |
| ------- | ----------- | -------- | ------- |
| AC1Lv1  | USB2        | 277      | 281     |
| AC1Lv1  | USB3        | 305      | 489     |
| AC1Lv2  | USB2        | 307      | 301     |
| AC1Lv2  | USB3        | **485**  | **649** |
| AC3Lv1  | USB2        | 279      | 285     |
| AC3Lv1  | USB3        | 307      | 496     |
| AC3Lv2  | USB2        | 308      | 298     |
| AC3Lv2  | USB3        | **485**  | **648** |
| AC5L    | USB2        | **253**  | **301** |
| AC5L    | USB3        | 252      | 301     |
| AX1L    | USB2        | 302      | 335     |
| AX1L    | USB3        | **681**  | **847** |

## Test environment

- Router: [ioGiant WiFi 6 AX1800](https://iogiant.com/products/wifi-6-router)
- Wi-Fi network (5 GHz band): `E8:65:D4:D0:F0:79 test5G Infra 36 270 Mbit/s  100 ▂▄▆█ WPA2 WPA3`
- iperf server: i3 8100, 10ec:8168 RTL8111/r8169 Ethernet adapter, connected to the router LAN2 port
- iperf client: i5-4440, Wi-Fi adapters connected either to a "back" USB port (directly on the motherboard), or via a cradle (extension cord, provided only with AC3L)
- Iperf server command: `iperf -s -xS`
- Iperf client command:  `iperf -c iperf-server -r`
- No obstacles, distance around 1 meter
- The adapters were switched to [USB3 mode](../usb3/) when connected to a USB3 port

## Remarks

- AC5L is a USB2 adapter, so connecting it to a USB3 port made no difference.
- In some cases, moving the router antennas even slightly made a huge difference in the speed test.
- In some cases, when using a USB cradle (provided only with AC3L), its positioning made a huge difference in the speed test.
- The upload speed might be faster because the i5 can encrypt faster than the router, or because the signal has fewer collisions/reflections traveling in that direction, or because of a driver/software issue on either side.
