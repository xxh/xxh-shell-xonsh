import sys, argparse
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
$PYTHONPACKAGES = $PIPHOME / 'lib/python3.8/site-packages'
$PIP_XONTRIB_TARGET = $PYTHONPACKAGES / 'xontrib'
$PYTHONPATH = [$PYTHONPACKAGES]
$PATH = [f'{$PIPHOME}/bin'] + $PATH
sys.path.append(str($PYTHONPACKAGES)) # Fix: https://github.com/xonsh/xonsh/issues/3461
sys.path.remove('') if '' in sys.path else None

if not $PIP_XONTRIB_TARGET.exists(): # Fix: https://github.com/xonsh/xonsh/issues/3461
    mkdir -p @($PIP_XONTRIB_TARGET)

def _xxh_pip(args):
    if args and 'install' in args and '-h' not in args and '--help' not in args:
        python -m pip @(args) --user
    else:
        python -m pip @(args)

aliases['pip'] = _xxh_pip
aliases['xpip'] = _xxh_pip
del _xxh_pip

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
