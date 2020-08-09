---
parent: Troubleshooting
---

# Busybox https

As we state in our [installation page](/), in distributions that are based on Debian Stretch, the `busybox` word should be omitted from the installation command, because their busybox package is too old and it doesn't support https, resulting in the following error:

```shell
wget: not an http or ftp url: deb.trendtechcn.com/install
```

So, the installation command should be:

```shell
sh -c 'wget deb.trendtechcn.com/install -O /tmp/install && sh /tmp/install'
```
