---
parent: Troubleshooting
---

# Unsupported arch

As stated in our [product page on Amazon](https://www.amazon.com/gp/product/B07FCN6WGX/ref=ask_ql_qh_dp_hza), our driver is only officially supported on PCs (x86_32, x86_64) and Raspberry Pi 2+ (armhf). To see your architecture, run:

```shell
uname -m
```

So if for example you have Raspberry Pi with Kali Linux installed, the output there could be "aarch64", which would mean that our driver cannot be compiled on that kernel. But if you install Raspbian with the stock kernel which is armhf, it will work.

If you do need to use an unsupported architecture and you haven't noticed that limitation before buying our adapter, please feel free to return it and ask for a full refund, as we're providing 2 years warranty for it.
