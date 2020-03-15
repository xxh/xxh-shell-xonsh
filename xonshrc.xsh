import sys, argparse
from base64 import b64decode

del $LS_COLORS # https://github.com/xonsh/xonsh/issues/3055

$XXH_VERBOSE = $XXH_VERBOSE if 'XXH_VERBOSE' in ${...} else False

$UPDATE_OS_ENVIRON=True
$XXH_HOME = pf"{__file__}".absolute().parent.parent.parent.parent.parent

$PIP_TARGET = $XXH_HOME / 'pip'
$PIP_XONTRIB_TARGET = $PIP_TARGET / 'xontrib'
if not $PIP_XONTRIB_TARGET.exists():
    mkdir -p @($PIP_XONTRIB_TARGET)

$PYTHONPATH = $PIP_TARGET
$PATH = [ p"$PYTHONHOME" / 'bin', $XXH_HOME ] + $PATH
sys.path.append(str($PIP_TARGET))
sys.path.remove('') if '' in sys.path else None
aliases['pip'] = ['python','-m','pip']

def _xxh_pip(args): # https://github.com/xonsh/xonsh/issues/3463
    if args and 'install' in args and '-h' not in args and '--help' not in args:
        print('\033[0;33mRun xpip in xontrib safe mode\033[0m')
        pip_xontrib_tmp = $PIP_XONTRIB_TARGET.parent / 'xontrib-safe'
        mv @($PIP_XONTRIB_TARGET) @(pip_xontrib_tmp)
        pip @(args)
        mkdir -p @($PIP_XONTRIB_TARGET)
        if list(pip_xontrib_tmp.glob('*')):
            bash -c $(echo mv @(pip_xontrib_tmp / '*') @($PIP_XONTRIB_TARGET))
        rm -r @(pip_xontrib_tmp)
    else:
        pip @(args)

aliases['xpip'] = _xxh_pip
del _xxh_pip

if 'APPDIR' in ${...}:
    aliases['xonsh'] = [$APPDIR+'/AppRun']

prefix_exe = 'XXH_SHELL_XONSH_APPIMAGE_EXE'
for e in ${...}:
    if e.startswith(prefix_exe):
        code = b64decode(${e})
        if $XXH_VERBOSE:
            print(f'Execute {repr(code)}')
        exec(code)

for plugin_path in sorted(($XXH_HOME / 'xxh/plugins').glob('*xonsh*')):
    if (plugin_path / 'build/pluginrc.xsh').exists():
        plugin_path = plugin_path / 'build'
        cd @(plugin_path)
        sys_path = sys.path
        sys.path += [str(plugin_path)]
        __import__('pluginrc')
        del sys.modules['pluginrc']
        sys.path = sys_path
cd
