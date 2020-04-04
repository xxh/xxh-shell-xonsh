import sys, argparse
from base64 import b64decode

del $LS_COLORS # https://github.com/xonsh/xonsh/issues/3055

$XXH_VERBOSE = $XXH_VERBOSE if 'XXH_VERBOSE' in ${...} else False

$UPDATE_OS_ENVIRON=True
$XXH_HOME = pf"{__file__}".absolute().parent.parent.parent.parent.parent

$PIP_TARGET = $XXH_HOME / '.pip'
$PIP_XONTRIB_TARGET = $PIP_TARGET / 'xontrib'
if not $PIP_XONTRIB_TARGET.exists():
    mkdir -p @($PIP_XONTRIB_TARGET)

$PYTHONPATH = $PIP_TARGET
$PATH = [$PIP_TARGET/'bin', f'{$PYTHONHOME}/bin', f'{$PYTHONHOME}/../../usr/bin' ] + $PATH
sys.path.append(str($PIP_TARGET))
sys.path.remove('') if '' in sys.path else None

def _xxh_pip(args):
    if args and 'install' in args and '-h' not in args and '--help' not in args:
        safe_dirs = ['bin', 'xontrib'] # https://github.com/pypa/packaging.python.org/issues/700
        try:
            for sd in safe_dirs:
                mkdir -p @($PIP_TARGET / sd)
                mv @($PIP_TARGET / sd) @($PIP_TARGET / (sd + '-safe'))
                mkdir -p @($PIP_TARGET / sd)
            python -m pip @(args)
        finally:
            for sd in safe_dirs:
                bash -c $(echo mv @($PIP_TARGET / sd / '*') @($PIP_TARGET / (sd + '-safe') ) "2> /dev/null")
                rm -r @($PIP_TARGET / sd)
                mv @($PIP_TARGET / (sd + '-safe')) @($PIP_TARGET / sd)
    else:
        python -m pip @(args)

aliases['pip'] = _xxh_pip
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

for plugin_path in sorted(($XXH_HOME / '.xxh/plugins').glob('*xonsh*')):
    if (plugin_path / 'build/pluginrc.xsh').exists():
        plugin_path = plugin_path / 'build'
        cd @(plugin_path)
        sys_path = sys.path
        sys.path += [str(plugin_path)]
        __import__('pluginrc')
        del sys.modules['pluginrc']
        sys.path = sys_path
cd
