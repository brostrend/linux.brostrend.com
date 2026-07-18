---
nav_exclude: true
---

# USB to Ethernet adapters

This page provides documentation for the following Brostrend USB to Ethernet adapters:

| Model                                | Description                                               | Minimum kernel                                                                   | Chipset      | USB-ID    |
| ------------------------------------ | --------------------------------------------------------- | -------------------------------------------------------------------------------- | ------------ | --------- |
| [U6](https://www.brostrend.com/u6)   | USB-C to 10 Gigabit Ethernet Adapter                      | [7.2 (2026-08-xx)](https://www.phoronix.com/news/Realtek-RTL8159-Linux-7.2)      | RTL8159      | 0bda:815a |
| [U5](https://www.brostrend.com/u5)   | USB-C to 5 Gbps Ethernet Adapter                          | [7.1 (2026-06-14)](https://www.phoronix.com/news/Linux-7.1-Networking)           | RTL8157-CG   | 0bda:8157 |
| [U5A](https://www.brostrend.com/u5a) | USB-A to 5 Gigabit Ethernet Adapter                       | [7.1 (2026-06-14)](https://www.phoronix.com/news/Linux-7.1-Networking)           | RTL8157-CG   | 0bda:8157 |
| [U2](https://www.brostrend.com/u2)   | USB-C to 2.5 Gbps Ethernet Adapter                        | [5.13 (2021-06-27)](https://www.phoronix.com/news/Realtek-RTL8153-RTL8156-Linux) | RTL8156BG-CG | 0bda:8156 |
| [U2C](https://www.brostrend.com/u2c) | USB-C to 2.5 Gigabit Ethernet Cable with Built-in Adapter | [5.13 (2021-06-27)](https://www.phoronix.com/news/Realtek-RTL8153-RTL8156-Linux) | RTL8156BG-CG | 0bda:8156 |

These adapters work out of the box in all Linux distributions that have at
least the minimum kernel version mentioned in the table, using the built-in
r8152 driver. They also work out of the box in older kernels, using a
"compatibility" driver called cdc_ncm that might prevent them from reaching
their full speeds. Furthermore, we provide an installer that is able to
install the correct r8152 drive in certain distributions even though they have
an older kernel. In that fallback scenario, the following distributions are
additionally supported:

- Ubuntu 20.04+, Debian 12+, Raspberry Pi OS 12+, ...

## Installer

> 💡 **Note:** The installer isn't available yet; it will be implemented in
> August 2026.

The best way to setup our USB to Ethernet adapters is to run our installer; see
the initial page for instructions:

- **<https://linux.brostrend.com>**

The installer will:

- Check if you're using the correct (r8152) or the compatibility (cdc_ncm)
  driver
- Try to install the correct r8152 driver if needed
- Report if your USB ports are fast enough for these adapters

## Manual installation

> 💡 **Tip:** If you follow our recommendation and run our installer, you don't
> need to read the rest of this page. If you want to have more control and do
> things manually, read on!

### Collect current information

To see the current information, open a terminal and run the following commands,
by copy/pasting the text after the $ signs. A sample output is included:

```shell
# See the current kernel version
$ uname -r
7.0.0-27-generic

# See the current driver and the USB negotiated speed
$ lsusb -tv | grep -B3 0bda:815
/:  Bus 002.Port 001: Dev 001, Class=root_hub, Driver=xhci_hcd/10p, 20000M/x2
    ID 1d6b:0003 Linux Foundation 3.0 root hub
    |__ Port 003: Dev 005, If 0, Class=Vendor Specific Class, Driver=r8152, 5000M
        ID 0bda:815a Realtek Semiconductor Corp.
```

Let's interpret this sample output, to see which parts we want to focus on. The
kernel version is 7.0. The USB ID is 0bda:815a, which means a U6 (10 Gbps)
adapter is connected. The driver name is r8152, and the negotiated speed of the
USB port is 5000M.

### Driver

The correct driver name is r8152. If you see that, it either means that your
kernel correctly supports the adapter, or that you've already ran our installer
which installed the r8152 driver for you.

The compatibility driver name is cdc_ncm. If you see that, you're not reaching
the adapter's full potential. In some cases you might see full speed; in others
it might be 1.2 Gbps instead of 10 Gbps. To resolve that, we recommend that you
run our installer. If you prefer to install the r8152 driver from elsewhere, a
github page and a PPA is available there:

https://github.com/awesometic/realtek-r8152-dkms

## Adapter speed

For our adapters to be able to reach their full speeds, three requirements must
be met:

- You must use the correct r8152 driver, as mentioned in the previous
  paragraphs
- Your USB ports must be faster than the adapter speed to account for the USB
  line encoding overhead (about 20%)
- The Ethernet cable and the device on the other end must support the adapter
  speed

### USB port speed

These are the USB versions and port speeds:

| USB Version       | Speed    | Slows down adapter  | Identical to          |
| ----------------- | -------- | ------------------- | --------------------- |
| Thunderbolt 3, 4+ | 40+ Gbps |                     |                       |
| USB4+             | 40+ Gbps |                     |                       |
| USB 3.2 Gen 2x2   | 20 Gbps  |                     |                       |
| USB 3.2 Gen 2x1   | 10 Gbps  | U6 (TODO test)      | USB 3.1 Gen2          |
| USB 3.2 Gen 1     | 5 Gbps   | U6, U5 (~3.75 Gbps) | USB 3.1 Gen1, USB 3.0 |

Let's focus again on the [sample output listed
above](#collect-current-information), and particularly on the lsusb command.
The first line mentions `20000M/x2`, which means the USB chipset does support
20 Gbps internally. But the third line mentions that the negotiated speed is
`5000M`, i.e. 5 Gbps instead of 10 Gbps, so the U6 adapter will be slower than
it can be. What is wrong?

For the explanation we'll need to consult the manufacturer's manual. In this
example, the [Dell Pro Slim Desktop QCS1250
specifications](https://www.dellstore.com/dell-pro-slim-desktop-bto009-qcs1250-i2x.html)
mention that the USB-C port in the front of the PC is USB 3.2 Gen 1 (5 Gbps),
while if we had bought the optional port module, we'd have a USB 3.2 Gen 2 (10
Gbps) port in the back.

### Ethernet speed

To check the Ethernet speed, we'll need two more terminal commands:

```shell
# See the adapter name
$ ip a
...
14: enx7419f81f260e: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 74:19:f8:1f:26:0e brd ff:ff:ff:ff:ff:ff

# See the Ethernet speed; install ethtool if you don't have it
$ sudo ethtool enx7419f81f260e
Settings for enx7419f81f260e:
        Supported ports: [ MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                2500baseT/Full
                                5000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                2500baseT/Full
                                5000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
                                             1000baseT/Full
                                             10000baseT/Full
                                             2500baseT/Full
                                             5000baseT/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 10000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 32
        Transceiver: internal
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00007fff (32767)
                               drv probe link timer ifdown ifup rx_err tx_err tx_queued intr tx_done rx_status pktdata hw wol
        Link detected: yes
```

That's a lot of output to process! Let's start with the `Speed: 10000Mb/s`
part. It should be as fast as the adapter speed. For example, if we have a U6
adapter and we see 5000Mb/s there, it means that either the network card in the
other end of the cable doesn't support 10 Gbps, or that the cable isn't good
enough (Cat 6 or Cat 6A). We can verify that by looking at the `Link partner
advertised link modes`, which is telling us what the other end supports, while
`Supported link modes` is what our side supports.

Another issue you might face is if you're using the compatibility driver,
cdc_ncm. That one doesn't advertise the correct link modes and ends up with
irregular speeds like `Speed: 4294Mb/s` and `Duplex: Unknown! (255)`, which in
some cases may make 10G adapters reach only 1.2 Gbps! To avoid that, please
install the r8152 driver.
