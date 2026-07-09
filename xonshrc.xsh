import sys as _sys

class _xxh:
    """xxh-shell-xonsh RC file"""

    def __init__(self):
        self.CDIR = pf"{__file__}".absolute().parent

        self.set_env()
        self.fix_issues()
        self.register_aliases()
        self.exec_xxh_shell_code()
        self.load_plugins()


    def set_env(self):
        $XXH_VERBOSE = int(@.env.get('XXH_VERBOSE', 0))
        $XONSH_SHOW_TRACEBACK = $XXH_VERBOSE in [1,2]
        $XONSH_DEBUG = int($XXH_VERBOSE in [2])
        $XONSH_TRACE_SUBPROC = $XXH_VERBOSE in [2]
        $UPDATE_OS_ENVIRON=True
        $XXH_HOME = pf"{$XXH_HOME}"

        $PIPHOME = pf'{$XDG_CONFIG_HOME}'.parent / '.local'
        $PYTHONUSERBASE = $PIPHOME
        $PYTHONPACKAGES = $PIPHOME / 'lib/python3.11/site-packages'
        $PYTHONPATH = [$PYTHONPACKAGES]
        $PATH = [f'{$PIPHOME}/bin'] + $PATH    
        
        $PIP_XONTRIB_TARGET = $PYTHONPACKAGES / 'xontrib'

    def fix_issues(self):
        del $LS_COLORS # https://github.com/xonsh/xonsh/issues/3055
    
        # Fix: https://github.com/xonsh/xonsh/issues/3461
        _sys.path.append(str($PYTHONPACKAGES))
        if not $PIP_XONTRIB_TARGET.exists():
            mkdir -p @($PIP_XONTRIB_TARGET)

        _sys.path.remove('') if '' in _sys.path else None        

    def register_aliases(self):
        if 'APPDIR' in @.env:
            $PATH = [f'{$APPDIR}/usr/bin'] + $PATH
            aliases['xonsh'] = [$APPDIR + '/AppRun']
        else:
            extracted_appimage = fp'{self.CDIR}/xonsh-squashfs'
            if extracted_appimage.exists():
                $PATH = [f'{self.CDIR}/xonsh-squashfs/usr/bin'] + $PATH
                aliases['xonsh'] = [f'{self.CDIR}/xonsh-squashfs/AppRun']
            else:
                print('Extracted xonsh AppImage not found!', file=_sys.stderr)    
    
        # Maybe this is not neede because https://github.com/xonsh/xonsh/pull/4922
        @aliases.register("pip-appimage")
        def _xxh_pip(args):
            py = $APPDIR + '/opt/python3.11/bin/python3.11' if 'APPDIR' in @.env else 'python'
            if args and 'install' in args and '-h' not in args and '--help' not in args:
                @(py) -m pip @(args) --user
            else:
                @(py) -m pip @(args)

        
    def exec_xxh_shell_code(self):
        prefix_exe = 'XXH_SHELL_XONSH_APPIMAGE_EXE'
        for e in @.env:
            if e.startswith(prefix_exe):
                code = @.imp.base64.b64decode(${e})
                if $XXH_VERBOSE:
                    print(f'Execute {repr(code)}')
                exec(code)

    def load_plugins(self):
        for xsh in sorted(($XXH_HOME / '.xxh/plugins').glob('**/build/*pluginrc.xsh')) + [$XXH_HOME / '.xonshrc']:
            if xsh.exists():
                source @(xsh)

__xonsh__.xxh = _xxh()
cd $HOME
