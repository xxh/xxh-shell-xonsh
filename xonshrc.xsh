import sys, argparse
from base64 import b64decode

del $LS_COLORS # https://github.com/xonsh/xonsh/issues/3055

if 'XXH_VERBOSE' in ${...}:
    $XXH_VERBOSE = int($XXH_VERBOSE)
else:
    $XXH_VERBOSE = 0

if $XXH_VERBOSE in [1,2]:
    $XONSH_SHOW_TRACEBACK = True

if $XXH_VERBOSE in [2]:
    $XONSH_DEBUG = 1
    $XONSH_TRACE_SUBPROC = True

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
$PYTHONPACKAGES = $PIPHOME / 'lib/python3.11/site-packages'
$PIP_XONTRIB_TARGET = $PYTHONPACKAGES / 'xontrib'
$PYTHONPATH = [$PYTHONPACKAGES]
$PATH = [f'{$PIPHOME}/bin'] + $PATH

# Fix: https://github.com/xonsh/xonsh/issues/3461
sys.path.append(str($PYTHONPACKAGES))
if not $PIP_XONTRIB_TARGET.exists():
    mkdir -p @($PIP_XONTRIB_TARGET)

sys.path.remove('') if '' in sys.path else None

def _xxh_pip(args):
    if 'APPDIR' in ${...}:
        py = $APPDIR + '/opt/python3.11/bin/python3.11'
    else:
        py = 'python'

    if args and 'install' in args and '-h' not in args and '--help' not in args:
        @(py) -m pip @(args) --user
    else:
        @(py) -m pip @(args)

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

for xsh in sorted(($XXH_HOME / '.xxh/plugins').glob('**/build/*pluginrc.xsh')) + [$XXH_HOME / '.xonshrc']:
    if xsh.exists():
        source @(xsh)

cd $HOME
