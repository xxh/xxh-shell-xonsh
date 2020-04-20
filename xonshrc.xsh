import sys
from base64 import b64decode

del $LS_COLORS # https://github.com/xonsh/xonsh/issues/3055

if 'XXH_VERBOSE' in ${...}:
    $XXH_VERBOSE = int($XXH_VERBOSE)
else:
    $XXH_VERBOSE = 0

if $XXH_VERBOSE in [1,2]:
    $XONSH_SHOW_TRACEBACK = True

$UPDATE_OS_ENVIRON=True
$XXH_HOME = pf"{$XXH_HOME}"
CDIR = pf"{__file__}".absolute().parent

if 'APPDIR' in ${...}:
    $PATH = [f'{$APPDIR}/usr/bin'] + $PATH
    aliases['xonsh'] = [$APPDIR + '/AppRun']
else:
    extracted_appimage = fp'{CDIR}/xonsh-squashfs'
    if extracted_appimage.exists():
        $PATH = [f'{CDIR}/xonsh-squashfs/usr/bin'] + $PATH
        aliases['xonsh'] = [f'{CDIR}/xonsh-squashfs/AppRun']
    else:
        print('Extracted xonsh AppImage not found!', file=sys.stderr)

$PIPHOME = pf'{$XDG_CONFIG_HOME}'.parent / '.local'
$PYTHONUSERBASE = $PIPHOME
$PYTHONPATH = $PIPHOME / 'lib/python3.8/site-packages'
$PATH = [f'{$PIPHOME}/bin'] + $PATH

aliases['pip'] = 'python -m pip'
aliases['xpip'] = 'python -m pip'

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
