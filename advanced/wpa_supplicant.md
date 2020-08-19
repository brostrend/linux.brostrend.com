---
nav_exclude: true
---

# WPA Supplicant

It's sometimes helpful to troubleshoot connection issues with the most basic tools, instead of testing with higher level tools like network manager. The following steps are based on the [ArchLinux wiki](https://wiki.archlinux.org/index.php/wpa_supplicant).

First, click on the network applet and select "Disable Wi-Fi", so that the wifi adapter is not in use. Then, create a file named /tmp/wpa_supplicant.conf, with the following contents:

```shell
ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=sudo

# Put your country code here (ISO/IEC alpha2 code):
country=US

network={
    # Put your wifi network and password here:
	ssid="mywifi"
	psk="mypassword"
}
```

Then open a terminal, and execute the following commands:

```shell
# If the wifi adapter is blocked, unblock it
$ rfkill list
0: phy0: Wireless LAN
	Soft blocked: yes
	Hard blocked: no

$ sudo rfkill unblock 0
$ rfkill list
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no

# See the wifi adapter name, for example wlx74ee2ae2436a or wlan0:
$ ip l
...
4: wlx74ee2ae2436a: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000

# Run wpa_supplicant. Put your wifi adapter name below:
$ sudo wpa_supplicant -i wlx74ee2ae2436a -c /tmp/wpa_supplicant.conf
Successfully initialized wpa_supplicant
wlx74ee2ae2436a: Trying to associate with 94:4a:0c:b8:bc:69 (SSID='plinetio5' freq=5180 MHz)
wlx74ee2ae2436a: Associated with 94:4a:0c:b8:bc:69
wlx74ee2ae2436a: CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
wlx74ee2ae2436a: CTRL-EVENT-REGDOM-CHANGE init=COUNTRY_IE type=COUNTRY alpha2=GR
wlx74ee2ae2436a: WPA: Key negotiation completed with 94:4a:0c:b8:bc:69 [PTK=CCMP GTK=TKIP]
wlx74ee2ae2436a: CTRL-EVENT-CONNECTED - Connection to 94:4a:0c:b8:bc:69 completed [id=0 id_str=]
```

That means that "wifi association" worked. If it works with the lower level tools, but not with the higher ones, it's a misconfiguration somewhere.
