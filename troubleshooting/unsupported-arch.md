---
parent: Troubleshooting
---

# Unsupported arch

As stated in our [product page on Amazon](https://www.amazon.com/gp/product/B07FCN6WGX/ref=ask_ql_qh_dp_hza), our driver is only officially supported on PCs (x86_32, x86_64) and Raspberry Pi 2+ (Raspbian armhf, Kali aarch64). To see your architecture, run:

```shell
uname -m
```

So if for example you see `powerpc` there, or if you try to run Raspbian with the [experimental kernel8.img kernel](https://github.com/RPi-Distro/repo/issues/157#issuecomment-581576549), then you architecture isn't supported.

If you do need to use an unsupported architecture and you haven't noticed that limitation before buying our adapter, please feel free to return it and ask for a full refund, as we're providing 2 years warranty for it.
