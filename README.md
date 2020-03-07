Python-powered [xonsh shell](https://xon.sh) entrypoint for [xxh](https://github.com/xxh/xxh).

## Install

The xxh-shell-xonsh-appimage is supported by default when you're using xxh. 
It will be installed during first connection. 

You could install and try it it manually:
```
cd ~/.xxh/xxh/shells/
git clone https://github.com/xxh/xxh-shell-xonsh-appimage
xonsh xxh-shell-xonsh-appimage/build.xsh
xxh myhost +s xxh-shell-xonsh-appimage
```

## Plugins

**xonsh xxh plugin** is the set of xsh scripts which will be run when you'll use xxh. You can create xxh plugin with your lovely aliases, tools or color theme and xxh will bring them to your ssh sessions.

🔎 [Search xxh plugins on Github](https://github.com/search?q=xxh-plugin-xonsh&type=Repositories) or [Bitbucket](https://bitbucket.org/repo/all?name=xxh-plugin-xonsh) or 💡 [Create xxh plugin](https://github.com/xxh/xxh-plugin-xonsh-sample)

Pinned xxh xonsh plugins: [pipe-liner](https://github.com/xxh/xxh-plugin-xonsh-pipe-liner), [theme-bar](https://github.com/xxh/xxh-plugin-xonsh-theme-bar), [autojump](https://github.com/xxh/xxh-plugin-xonsh-autojump).
  
## Notes

### Using python, pip and [xontribs](https://xon.sh/xontribs.html)

The xxh is using pip and python from `xonsh.AppImage` by default. You can update pip (`pip install --upgrade pip`) and install packages ordinally: `pip install --upgrade pandas`. The packages will appear in host xxh home `~/.xxh/pip` by default.

To install [xontribs](https://xon.sh/xontribs.html) in xxh session use `xpip install <package>`. Never use `pip` to install xontribs ([details](https://github.com/xonsh/xonsh/issues/3463)).

## Thanks
* @probonopd for https://github.com/AppImage
* @niess for https://github.com/niess/linuxdeploy-plugin-python/ 
