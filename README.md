<p align="center">  
The <a href="https://xon.sh">xonsh shell</a> entrypoint for <a href="https://github.com/xxh/xxh">xxh</a>. Use xonsh wherever you go through the SSH without installation on the host. 
</p> 

<p align="center">  
If you like the idea click ⭐ on the repo and <a href="https://twitter.com/intent/tweet?text=Use%20the%20xonsh%20shell%20wherever%20you%20go%20through%20the%20SSH%20without%20installation%20on%20the%20host.&url=https://github.com/xxh/xxh-shell-xonsh" target="_blank">tweet</a>.
</p>

## Install

Install from xxh repo:
```bash
xxh +I xxh-shell-xonsh
# or from repo: xxh +I xxh-shell-xonsh+git+https://github.com/xxh/xxh-shell-xonsh
```
## Connect
``` 
xxh yourhost +s xonsh +if
```
To avoid adding `+s` every time use xxh config in `~/.config/xxh/config.xxhc` (`$XDG_CONFIG_HOME`):
```
hosts:
  ".*":                     # Regex for all hosts
    +s: xonsh
```

## Using python, pip and [xontribs](https://xon.sh/xontribs.html)

The `xonsh.AppImage` has `python` and `pip` by default. You can update pip and install packages and [xontribs](https://github.com/topics/xontrib) ordinarily: 
```xsh
myhost> pip install -U pip
myhost> pip install pandas
myhost> xpip install xontrib-prompt-bar
``` 

Packages location comply with [hermetic principle](https://github.com/xxh/xxh/wiki#the-ideas-behind-xxh):

| xxh command | pip packages home | user home |
| ------- | ---------- | --------- |
| `xxh myhost` | `/home/user/.xxh/.local` | `/home/user/.xxh` |
| `xxh myhost +hhh '~'` | `/home/user/.xxh/.local` | `/home/user` | 
| `xxh myhost +hhh '~' +hhx '~'` | `/home/user/.local` | `/home/user` |

## Plugins

**xonsh xxh plugin** is the set of xsh scripts which will be run when you'll use xxh. You can create xxh plugin with your lovely aliases, tools or color theme and xxh will bring them to your ssh sessions.

Pinned xxh xonsh plugins: [autojump](https://github.com/xxh/xxh-plugin-xonsh-autojump).

🔎 [Search xxh plugins on Github](https://github.com/search?q=xxh-plugin-xonsh&type=Repositories) or [Bitbucket](https://bitbucket.org/repo/all?name=xxh-plugin-xonsh) or 💡 [Create xxh plugin](https://github.com/xxh/xxh-plugin-xonsh-example)

## Seamless mode
Add environment variables to `env` file and bring them to the host using `source` command:
```shell script
source xxh.xsh myhost
```
  
## Alpine Linux  
  
* [How to run xonsh AppImage on Alpine?](https://github.com/xonsh/xonsh/discussions/4158#discussioncomment-462032)
  
## Thanks
* @probonopd for https://github.com/AppImage
* @niess for https://github.com/niess/linuxdeploy-plugin-python/ 
