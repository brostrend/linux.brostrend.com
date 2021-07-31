---
parent: Troubleshooting
---

# Alternative installation commands

The following installation lines are all equivalent; try them in order until one of them succeeds:

```shell
sh -c 'wget deb.trendtechcn.com/install -O /tmp/install && sh /tmp/install'
sh -c 'busybox wget deb.trendtechcn.com/install -O /tmp/install && sh /tmp/install'
sh -c 'curl deb.trendtechcn.com/install -Lo /tmp/install && sh /tmp/install'
```

Some failure messages and the reasons for them are:
 * `wget: command not found`: means that wget isn't installed. Either install wget from your package manager, or use one of the other commands.
 * `wget: not an http or ftp url: deb.trendtechcn.com/install`: this is shown by old busybox versions that don't support https. Use one of the other commands.
* `curl: command not found`: means that curl isn't installed. Either install curl from your package manager, or use one of the other commands.
* `/tmp/install: Permission denied`: means that you previously ran that command as root, while now you're running it again as a user. Please remove the file with `sudo rm /tmp/install`, then run the installation command again.
