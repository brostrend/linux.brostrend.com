---
nav_exclude: true
---

# Monitor mode

[Monitor mode](https://en.wikipedia.org/wiki/Monitor_mode), or RFMON (Radio Frequency MONitor) mode, allows a computer with a wireless network interface controller (WNIC) to monitor all traffic received on a wireless channel. We will describe three alternative ways and tools to put our adapters in monitor mode.

Before continuing, you might want to disable Network Manager with `sudo systemctl stop NetworkManager`, as it may be keeping the wireless interface in use.

## Using ip and iw

```shell
sudo ip link set wlan0 down
sudo iw wlan0 set type monitor
sudo ip link set wlan0 up
sudo iw dev
# OUTPUT:
phy#0
        Interface wlan0
                ifindex 3
                wdev 0x1
                addr de:f3:5d:be:92:72
                type monitor
                txpower -100.00 dBm
```

To go back to the default managed mode, run `sudo iw wlan0 set type managed`.

## Using ifconfig and iwconfig

```shell
sudo ifconfig wlan0 down
sudo iwconfig wlan0 mode monitor
sudo ifconfig wlan0 up
sudo iwconfig
# OUTPUT:
wlan0 unassociated  Nickname:"<WIFI@REALTEK>"
      Mode:Monitor  Frequency=2.427 GHz  Access Point: Not-Associated
      Sensitivity:0/0
      Retry:off   RTS thr:off   Fragment thr:off
      Encryption key:off
      Power Management:off
      Link Quality=0/100  Signal level=0 dBm  Noise level=0 dBm
      Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
      Tx excessive retries:0  Invalid misc:0   Missed beacon:0
```

To go back to the default managed mode, run `sudo iwconfig wlan0 mode managed`.

## Using airmon-ng

```shell
sudo airmon-ng start wlan0
# OUTPUT:
PHY     Interface       Driver          Chipset

phy0    wlan0           rtl88x2bu       Realtek Semiconductor Corp. RTL88x2bu [AC1200 Techkey]
                (monitor mode enabled)
```

To go back to the default managed mode, run `sudo airmon-ng stop wlan0`

## Monitoring traffic

One way to monitor traffic is with the `airodump-ng` command:

```shell
sudo airodump-ng wlan0
# OUTPUT:
[ CH 13 ][ Elapsed: 36 s ][ 2021-04-18 09:23

 BSSID              PWR  Beacons  #Data, #/s  CH   MB   ENC CIPHER  AUTH ESSID

 14:60:80:98:A1:00  -64        6      0    0   9   65   WPA2 CCMP   PSK  Hlia
 7C:39:53:84:ED:D4  -69        4      0    0   1  270   WPA2 CCMP   PSK  nico
 3C:84:6A:05:BE:BC  -70        3      0    0   6  130   WPA2 CCMP   PSK  VODA
```

Please note though that we have no further documentation nor experience on using the [aircrack-ng suite](https://www.aircrack-ng.org), so users should consult the upstream documentation for it.
