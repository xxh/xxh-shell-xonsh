Python-powered [xonsh shell](https://xon.sh) entrypoint for [xxh](https://github.com/xxh/xxh).

## Plugins

**xxh plugin** is the set of xsh scripts which will be run when you'll use xxh. You can create xxh plugin with your lovely aliases, tools or color theme and xxh will bring them to your ssh sessions.

🔎 [Search xxh plugins on Github](https://github.com/search?q=xxh-plugin&type=Repositories) or [Bitbucket](https://bitbucket.org/repo/all?name=xxh-plugin) or 💡 [Create xxh plugin](https://github.com/xxh/xxh-plugin-xonsh-sample)

Pinned xxh xonsh plugins:

* [xxh-plugin-xonsh-pipe-liner](https://github.com/xxh/xxh-plugin-xonsh-pipe-liner) — processing the lines easy with python and classic shell pipes
* [xxh-plugin-xonsh-theme-bar](https://github.com/xxh/xxh-plugin-xonsh-theme-bar) — theme to stay focused
* [xxh-plugin-xonsh-autojump](https://github.com/xxh/xxh-plugin-xonsh-autojump) — save time on moving thru directories
  
## Notes

### Using python, pip and [xontribs](https://xon.sh/xontribs.html)

The xxh is using pip and python from `xonsh.AppImage` by default. You can update pip (`pip install --upgrade pip`) and install packages ordinally: `pip install --upgrade pandas`. The packages will appear in host xxh home `~/.xxh/pip` by default.

To install [xontribs](https://xon.sh/xontribs.html) in xxh session use `xpip install <package>`. Never use `pip` to install xontribs ([details](https://github.com/xonsh/xonsh/issues/3463)).

## Thanks
* @scopatz for https://github.com/xonsh/xonsh
* @probonopd for https://github.com/AppImage
* @niess for https://github.com/niess/linuxdeploy-plugin-python/
* @gforsyth for https://github.com/xonsh/xonsh/issues/3374
