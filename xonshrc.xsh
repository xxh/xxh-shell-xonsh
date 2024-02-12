import sys, argparse
from base64 import b64decode

del $LS_COLORS # https://github.com/xonsh/xonsh/issues/3055

$XXH_VERBOSE = int(__xonsh__.env.get('XXH_VERBOSE', 0))
$XONSH_SHOW_TRACEBACK = $XXH_VERBOSE in [1,2]
$XONSH_DEBUG = int($XXH_VERBOSE in [2])
$XONSH_TRACE_SUBPROC = $XXH_VERBOSE in [2]
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

# Maybe this is not neede because https://github.com/xonsh/xonsh/pull/4922
@aliases.register("pip-appimage")
def _xxh_pip(args):
    py = $APPDIR + '/opt/python3.11/bin/python3.11' if 'APPDIR' in ${...} else 'python'
    if args and 'install' in args and '-h' not in args and '--help' not in args:
        @(py) -m pip @(args) --user
    else:
        @(py) -m pip @(args)

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
