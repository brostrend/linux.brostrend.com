---
nav_exclude: true
---

# Monitor mode

[Monitor mode](https://en.wikipedia.org/wiki/Monitor_mode), or RFMON (Radio Frequency MONitor) mode, allows a computer with a wireless network interface controller (WNIC) to monitor all traffic received on a wireless channel.

Our drivers are compiled with the ability to dynamically enable monitor mode when desired, by running the following commands:


```shell
sudo ip link set wlan0 down
sudo iw dev wlan0 set type monitor
sudo ip link set wlan0 up
```
