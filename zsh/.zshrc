# .zshrc

########################################################################
# Colors
########################################################################
autoload -U colors && colors

# ls with color
if [ "$TERM" != "dumb" ]; then
    if [ "$(uname)" = 'Linux' ]; then
        alias ls='ls --color=auto'
        # Solarized Light palette (xterm-256color approximations):
        # blue=33 cyan=37 green=64 yellow=136 orange=166 red=160
        # magenta=125 violet=61 base2=254 base3=230
        export LS_COLORS="rs=0:di=01;38;5;33:ln=01;38;5;37:mh=00:pi=48;5;230;38;5;136:so=01;38;5;125:do=01;38;5;125:bd=48;5;230;38;5;136;01:cd=48;5;230;38;5;136;01:or=48;5;230;38;5;160;01:mi=00:su=38;5;230;48;5;160:sg=30;48;5;136:ca=30;48;5;160:tw=38;5;230;48;5;64:ow=38;5;33;48;5;64:st=38;5;230;48;5;33:ex=01;38;5;64:*.tar=01;38;5;166:*.tgz=01;38;5;166:*.tar.gz=01;38;5;166:*.gz=01;38;5;166:*.zip=01;38;5;166:*.rar=01;38;5;166:*.7z=01;38;5;166:*.bz2=01;38;5;166:*.xz=01;38;5;166:*.zst=01;38;5;166:*.deb=01;38;5;166:*.rpm=01;38;5;166:*.jpg=38;5;125:*.jpeg=38;5;125:*.png=38;5;125:*.gif=38;5;125:*.bmp=38;5;125:*.svg=38;5;125:*.tiff=38;5;125:*.mp3=38;5;61:*.flac=38;5;61:*.wav=38;5;61:*.mp4=38;5;61:*.mkv=38;5;61:*.avi=38;5;61:*.mov=38;5;61:*.pdf=38;5;136:*.doc=38;5;136:*.docx=38;5;136:*.md=38;5;244"
    else
        alias ls='ls -G'
        # export LSCOLORS=GxFxCxDxBxegedabagaced
        export LSCOLORS=ExFxCxDxBxEGEDABAGACAD
    fi
    export CLICOLOR=1
fi

########################################################################
# Prompt
########################################################################
# autoload -U promptinit && promptinit
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT
# PS1="%{$fg_bold[green]%}%n@%m %{$fg_bold[yellow]%}%1~ $%{$reset_color%} "
# PS1="%{$fg_bold[green]%}%1~ %{$fg_bold[yellow]%}$%{$reset_color%} "
PS1="%{$fg_bold[green]%}%n@%m %{$fg_bold[yellow]%}%~ "$'\n'"$%{$reset_color%} "

# Allow Emacs to track the current directory
# if [ -n "$INSIDE_EMACS" ]; then
#     chpwd() { print -P "\033AnSiTc %d" }
#     print -P "\033AnSiTu %n"
#     print -P "\033AnSiTc %d"
# fi

# Emacs tramp
if [[ $TERM == "dumb" ]]; then # in emacs
    PS1='%(?..[%?])%!:%~%# '
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    (( $+functions[precmd] )) && unfunction precmd
    (( $+functions[preexec] )) && unfunction preexec
fi

# Colors in man pages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

########################################################################
# History
########################################################################
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\ep" history-beginning-search-backward-end
bindkey "\en" history-beginning-search-forward-end

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

HISTFILE=$HOME/.zsh_history
HISTSIZE=12000
SAVEHIST=10000

########################################################################
# Key binds
########################################################################
bindkey "^K" kill-whole-line
bindkey "^R" history-incremental-search-backward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^N" history-search-forward
bindkey "^P" history-search-backward
bindkey "^D" delete-char
bindkey "^F" forward-char
bindkey "^B" backward-char
bindkey -e

########################################################################
# Completion
########################################################################
mkdir -p "$HOME/.zsh/cache"
autoload -U compinit && compinit
zmodload -i zsh/complist

setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt AUTO_NAME_DIRS
setopt AUTO_PARAM_SLASH
setopt AUTO_PARAM_KEYS
setopt AUTO_REMOVE_SLASH
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
setopt GLOB_COMPLETE
unsetopt LIST_AMBIGUOUS
setopt LIST_PACKED
setopt LIST_ROWS_FIRST
setopt LIST_TYPES

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zsh/cache/$HOST"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' rehash true
zstyle '*' single-ignored show

########################################################################
# SSH
########################################################################
# Reuse a running ssh-agent across shells instead of spawning a new one
# (and leaking orphaned agents) every time SSH_AUTH_SOCK isn't inherited.
SSH_ENV="$HOME/.ssh/agent-environment"

start_ssh_agent() {
    (umask 077; ssh-agent -s > "$SSH_ENV")
    source "$SSH_ENV" > /dev/null
}

if [ -f "$SSH_ENV" ]; then
    source "$SSH_ENV" > /dev/null
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        start_ssh_agent
    fi
else
    start_ssh_agent
fi

########################################################################
# Git
########################################################################
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*:*' get-revision true
precmd_vcs_info() {
    if [[ -z $(git ls-files --modified --other --exclude-standard 2> /dev/null) ]]; then
        zstyle ':vcs_info:*' formats "%{$fg_bold[blue]%}%s:%b%{$reset_color%} "
    else
        zstyle ':vcs_info:*' formats "%{$fg_bold[blue]%}%s:%b %{$fg_bold[red]%}(!)%{$reset_color%} "
    fi
    vcs_info
}
precmd_functions+=( precmd_vcs_info )
# setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_

# pkgfile
command -v pkgfile >/dev/null 2>&1 && source /usr/share/doc/pkgfile/command-not-found.zsh

########################################################################
# Tmux
########################################################################
function tmuxopen() {
    tmux attach -t "$1"
}

function tmuxnew() {
    tmux new -s "$1"
}

function tmuxkill() {
    tmux kill-session -t "$1"
}

########################################################################
# Misc options
########################################################################
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS

## Correction
setopt CORRECT
setopt CORRECT_ALL
CORRECT_IGNORE_FILE='.*'

# Changing directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

########################################################################
# Aliases
########################################################################
if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -Gv'
    alias ll='ls -lhGv'
    alias la='ls -aGv'
    alias lr='ls -RGv'
    alias l='ls -CFGv'
    alias top='top -o cpu -O +rsize -s 3 -n 50'
else
    alias ll='ls -lh'
    alias la='ls -a'
    alias lr='ls -R'
    alias l='ls -CF'
fi

# emacsclient
alias e='emacsclient -a "" -t'
alias ec='emacsclient -a "" -nc'
alias ew='emacs -nw --quick'

alias mkdir='mkdir -p -v'
alias mv='timeout 8 mv -iv'

if [ "$(uname)" = 'Darwin' ]; then
    alias rm='noglob timeout 3 rm -iv'
else
    alias rm='noglob timeout 3 rm -Iv --one-file-system'
fi

alias q='exit'
alias find='noglob find'
alias grep='grep --color=auto'
alias diff='diff -u --color=auto'
alias nano='nano -w'

alias r="source ~/.zshrc"
alias tat='tmux new-session -As $(basename "$PWD" | tr . -)'
alias tmuxsrc="tmux source-file ~/.tmux.conf"
alias tmuxkillall="tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}"

# Zsh-syntax-highlighting
if [ -d "$HOME/.zsh/plugins/zsh-syntax-highlighting" ]; then
    source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=cyan,underline
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=cyan,underline
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
fi

# ghcup-env
# [ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
