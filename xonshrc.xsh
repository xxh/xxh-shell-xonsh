import sys
from base64 import b64decode

del $LS_COLORS # https://github.com/xonsh/xonsh/issues/3055

$XXH_VERBOSE = $XXH_VERBOSE if 'XXH_VERBOSE' in ${...} else False

$UPDATE_OS_ENVIRON=True
$XXH_HOME = pf"{__file__}".absolute().parent.parent.parent.parent.parent

$PIPHOME = pf'{$XDG_CONFIG_HOME}'.parent / '.local'
$PYTHONUSERBASE = $PIPHOME
$PYTHONPATH = $PIPHOME / 'lib/python3.8/site-packages'
$PATH = [f'{$PIPHOME}/bin', f'{$APPDIR}/usr/bin'] + $PATH

aliases['pip'] = 'python -m pip'
aliases['xpip'] = 'python -m pip'

if 'APPDIR' in ${...}:
    aliases['xonsh'] = [$APPDIR+'/AppRun']

prefix_exe = 'XXH_SHELL_XONSH_APPIMAGE_EXE'
for e in ${...}:
    if e.startswith(prefix_exe):
        code = b64decode(${e})
        if $XXH_VERBOSE:
            print(f'Execute {repr(code)}')
        exec(code)

for plugin_path in sorted(($XXH_HOME / '.xxh/plugins').glob('*xonsh*')):
    if (plugin_path / 'build/pluginrc.xsh').exists():
        plugin_path = plugin_path / 'build'
        cd @(plugin_path)
        sys_path = sys.path
        sys.path += [str(plugin_path)]
        __import__('pluginrc')
        del sys.modules['pluginrc']
        sys.path = sys_path
cd $HOME
