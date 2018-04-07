# .zprofile

export LC_CTYPE=en_US.UTF-8
export LOCALE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export COPYFILE_DISABLE=true
export TERM='screen-256color'
export SUDO_EDITOR='/usr/bin/nano'
export EDITOR='/usr/bin/nano'

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# OS X
if [ $(uname) = 'Darwin' ]; then
    if [ -d /opt/local ]; then
        export PATH=/opt/local/bin:/opt/local/sbin:${PATH}
        export MANPATH=/opt/local/share/man:/opt/local/man:${MANPATH}

        # Python
        export PYTHONDIR=/opt/local/Library/Frameworks/Python.framework/Versions/Current

        # autojump
        export FPATH="$FPATH:/opt/local/share/zsh/site-functions/"
        if [ -f /opt/local/etc/profile.d/autojump.sh ]; then
            . /opt/local/etc/profile.d/autojump.sh
        fi
    fi

    if [ -d /usr/local ]; then
        export PATH=/usr/local/bin:${PATH}
        export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
        export MANPATH=/usr/local/share/man:${MANPATH}
    fi
fi

# Python
export WORKON_HOME=${HOME}/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    source /usr/bin/virtualenvwrapper_lazy.sh
fi

# ROOT
command -v root-config >/dev/null 2>&1 && export ROOTSYS=$(root-config --prefix)

# ccache
[[ -d /usr/lib/ccache ]] && export PATH=/usr/lib/ccache/bin:$PATH

# Cabal
if [ -d ${HOME}/Library/Haskell ]; then
    export PATH=${HOME}/Library/Haskell/bin:$PATH
elif [ -d ${HOME}/.cabal ]; then
    export PATH=${HOME}/.cabal/bin${PATH:+:$PATH}
fi

# Unison
if [ -x "$(command -v unison)" ]; then
    if [ $(uname) = 'Darwin' ]; then
        export UNISONLOCALHOSTNAME=${HOST}
    else
        export UNISONLOCALHOSTNAME=${HOST}.localdomain
    fi
fi

# For local things
[[ -d ${HOME}/.local/bin ]] && export PATH=${HOME}/.local/bin:${PATH}

# Nix
if [ -d ${HOME}/.nix-profile ]; then
    . ${HOME}/.nix-profile/etc/profile.d/nix.sh
    export MANPATH=${HOME}/.nix-profile/share/man:${MANPATH}

    # zsh
    if [ -d ${HOME}/.nix-profile/share/zsh/site-functions ]; then
        fpath=(${HOME}/.nix-profile/share/zsh/site-functions $fpath)
    fi

    # ghc
    if [ -e ~/.nix-profile/bin/ghc ]; then
        export NIX_GHC="$HOME/.nix-profile/bin/ghc"
        export NIX_GHCPKG="$HOME/.nix-profile/bin/ghc-pkg"
        export NIX_GHC_DOCDIR="$HOME/.nix-profile/share/doc/ghc/html"
        export NIX_GHC_LIBDIR="$HOME/.nix-profile/lib/ghc-$($NIX_GHC --numeric-version)"
    fi
fi

if [ -d ${HOME}/opt/local ]; then
    export PATH=${HOME}/opt/local/bin:${PATH}
    # export MANPATH=${HOME}/opt/local/share/man:${HOME}/opt/local/man:${MANPATH}
fi
