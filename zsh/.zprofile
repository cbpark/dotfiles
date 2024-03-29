# .zprofile

export LC_CTYPE=en_US.UTF-8
export LOCALE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export COPYFILE_DISABLE=true
export TERM='screen-256color'
# export SUDO_EDITOR='/usr/bin/nano'
export EDITOR='emacsclient -a \"\" -t'
export VISUAL=$EDITOR

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# Python
export WORKON_HOME=${HOME}/.virtualenvs
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    source /usr/bin/virtualenvwrapper_lazy.sh
fi

# ROOT
command -v root-config >/dev/null 2>&1 && export ROOTSYS=$(root-config --prefix)

# GSL
if command -v gsl-config >/dev/null 2>&1; then
    export C_INCLUDE_PATH=$(echo $(gsl-config --cflags) | cut -c 3-):$C_INCLUDE_PATH
fi

# ccache
[[ -d /usr/lib/ccache ]] && export PATH=/usr/lib/ccache/bin:$PATH

# Cabal
if [ -d ${HOME}/Library/Haskell ]; then
    export PATH=${HOME}/Library/Haskell/bin:$PATH
elif [ -d ${HOME}/.cabal ]; then
    export PATH=${HOME}/.cabal/bin${PATH:+:$PATH}
fi

# rustup
if [ -d ${HOME}/.cargo ]; then
    export PATH=${HOME}/.cargo/bin:$PATH
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
