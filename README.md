Python-powered [xonsh shell](https://xon.sh) entrypoint for [xxh](https://github.com/xxh/xxh).

## Install

Install from xxh repo:
```
xxh +I xxh-shell-xonsh-appimage
```
Install from any repo:
```
xxh +I xxh-shell-xonsh-appimage+git+https://github.com/xxh/xxh-shell-xonsh-appimage
```
Connect:
``` 
xxh yourhost +s xonsh-appimage +if
```
To avoid adding `+s` every time use xxh config in `~/.config/xxh/config.xxhc` (`$XDG_CONFIG_HOME`):
```
hosts:
  ".*":                     # Regex for all hosts
    +s: xonsh-appimage
```

## Using python, pip and [xontribs](https://xon.sh/xontribs.html)

The `xxh-shell-xonsh-appimage` is using pip and python from `xonsh.AppImage` by default. You can update pip (`pip install --upgrade pip`) and install packages ordinally: `pip install --upgrade pandas`. The packages will appear in host xxh home `~/.xxh/pip` by default.

To install [xontribs](https://xon.sh/xontribs.html) in xxh session use `xpip install <package>`. Never use `pip` to install xontribs ([details](https://github.com/xonsh/xonsh/issues/3463)).

## Plugins

**xonsh xxh plugin** is the set of xsh scripts which will be run when you'll use xxh. You can create xxh plugin with your lovely aliases, tools or color theme and xxh will bring them to your ssh sessions.

Pinned xxh xonsh plugins: [pipe-liner](https://github.com/xxh/xxh-plugin-xonsh-pipe-liner), [theme-bar](https://github.com/xxh/xxh-plugin-xonsh-theme-bar), [autojump](https://github.com/xxh/xxh-plugin-xonsh-autojump).

🔎 [Search xxh plugins on Github](https://github.com/search?q=xxh-plugin-xonsh&type=Repositories) or [Bitbucket](https://bitbucket.org/repo/all?name=xxh-plugin-xonsh) or 💡 [Create xxh plugin](https://github.com/xxh/xxh-plugin-xonsh-sample)

## Seamless mode
Add environment variables to `env` file and bring them to the host using `source` command:
```shell script
source xxh.xsh myhost
```
  
## Thanks
* @probonopd for https://github.com/AppImage
* @niess for https://github.com/niess/linuxdeploy-plugin-python/ 
