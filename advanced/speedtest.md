---
nav_exclude: true
---

# Speed test

We've conducted various speed tests with our adapters, so that you can see real
world results instead of the theoretical protocol speeds, to choose the adapter
that best suits your bandwidth requirements:

| Adapter       | Mode    | 2.4U | 2.4D |   5U |  5D |   6U |   6D |
| ------------- | ------- | ---: | ---: | ---: | --: | ---: | ---: |
| AX9L          | USB3,in |  390 |  406 |  790 | 864 |  794 |  859 |
| AX9L          | USB2,in |  303 |  275 |  301 | 284 |  301 |  283 |
| AX8L          | USB3    |  438 |  431 | 1470 | 901 | 1490 | 1650 |
| AX8L          | USB2    |  323 |  336 |  333 | 339 |  348 |  339 |
| AX7L          | USB2    |  210 |  207 |  350 | 332 |    - |    - |
| AX5L          | USB2    |  212 |  167 |    - |   - |    - |    - |
| AX4L/AX1L     | USB3    |  394 |  421 |  740 | 896 |    - |    - |
| AX4L/AX1L     | USB2    |  318 |  318 |  266 | 329 |    - |    - |
| AC5L          | USB2,in |  103 |  116 |  212 | 246 |    - |    - |
| AC5L          | USB2    |  141 |  152 |  264 | 243 |    - |    - |
| AC3Lv2/AC1Lv2 | USB3,in |  205 |  236 |  594 | 403 |    - |    - |
| AC3Lv2/AC1Lv2 | USB3    |  272 |  297 |  559 | 293 |    - |    - |
| AC3Lv2/AC1Lv2 | USB2,in |  190 |  230 |  227 | 103 |    - |    - |
| AC3Lv2/AC1Lv2 | USB2    |  276 |  239 |  331 | 237 |    - |    - |
| AC3Lv1/AC1Lv1 | USB3,in |  126 |  214 |  275 | 327 |    - |    - |
| AC3Lv1/AC1Lv1 | USB3    |  136 |  252 |  331 | 256 |    - |    - |
| AC3Lv1/AC1Lv1 | USB2,in |  137 |  228 |  277 | 245 |    - |    - |
| AC3Lv1/AC1Lv1 | USB2    |  132 |  214 |  306 | 246 |    - |    - |

## Remarks

- The following adapters can reach the same speeds and only differ in that the
  models with bigger antennas get a much better signal: AX4L=AX1L,
  AC3Lv2=AC1Lv2, AC3Lv1=AC1Lv1 (v1 was last sold in 2019).
- Mode **USB2** or **USB3** mean that the adapter was operating in USB2 or
  [USB3 port speed](../usb3/).
- Mode **in** means that the [in-kernel
  drivers](../../supported-distributions/#in-kernel-drivers) were tested
  instead of ours (Realtek's or AICSemi's).
- **2.4U**, **2.4D** etc are the upload and download speeds when the adapter
  was connected in the 2.4, 5 or 6 GHz Wi-Fi band.

## Test environment

- Server: Ubuntu 24.04, kernel 6.14.0-27, i3 8100, connected to the AP via a
  [BrosTrend P1L 2.5G Ethernet adapter](/p1l/), command: `iperf -s -xS`
- Client: Ubuntu 24.04, kernel 6.14.0-27, i3 8100, connected wirelessly to the
  AP, ran 3 times the following command and kept the best results: `iperf -c
  server-ip -r`
- Access point (router): [Mercusys
  MR47BE](https://www.mercusys.com/gr/product/details/mr47be/), EasyMesh: off,
  SmartConnect: off. AP configuration:
  - 2.4 GHz: WPA3 Personal, 40 MHz
  - NM: `30:16:9D:89:9E:88  test2g  Infra   2  270 Mbit/s  100  ▂▄▆█  WPA3`
  - 5 GHz: WPA3 Personal, 20/40/80/160 MHz, 802.11a/n/ac/ax/be mixed
  - NM: `30:16:9D:89:9E:89  test5g  Infra  48  270 Mbit/s  100  ▂▄▆█  WPA3`
  - 6 GHz: WPA3 Personal, 20/40/80/160/320 MHz, 802.11ax/be mixed
  - NM: `1E:16:9D:89:9E:8A  test6g  Infra   0   54 Mbit/s  100  ▂▄▆█  WPA3`
- The adapters were connected to the client using a 1 meter USB3 or USB2
  extension chord. The access point was 40cm away. Both were on top of paper
  boxes, away from surfaces that can cause loss of signal strength, reflections
  or collisions, such as walls, the floor, a desk or the PC/laptop itself. When
  the signal isn't ideal, the speed may drop significantly.
