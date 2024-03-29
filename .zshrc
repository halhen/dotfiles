# vim:ft=sh

autoload -U compinit && compinit
autoload -U colors && colors

# {{{ Exports
typeset -U path
path=( ~/.bin $path)

export AWT_TOOLKIT=MToolkit
export BROWSER="firefox"
export EDITOR="vim"
export LESS="-FiMRsX"
export MANWIDTH=80
export PAGER="less"
export OOO_FORCE_DESKTOP="gnome"
export MOZ_DISABLE_PANGO=1
export HOSTNAME=$(uname -n)
export GOPATH=$HOME/go

[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env
# }}}

# {{{ Python options
export PYTHONSTARTUP=$HOME/.pythonrc
export WORKON_HOME=~/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
which virtualenvwrapper.sh &>/dev/null && source virtualenvwrapper.sh
# }}}

# {{{ Shell options
setopt AUTO_RESUME
setopt BG_NICE
setopt CHECK_JOBS
setopt CORRECT
setopt EXTENDED_GLOB
setopt MULTIOS
setopt SHORT_LOOPS

bindkey -v
# Arrow up/down
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^R" history-incremental-search-backward

# Home/end
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line

# ^E to edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# ^L to pipe through $PAGER and execute
bindkey -s '^L' "|$PAGER\n"

# }}}

# {{{ Colors for console

# Use the color settings from ~/.Xdefaults in console
if [[ "$TERM" = "linux" ]]; then
    for i in $(sed -n 's/^\*color\(.*\):.*#\(.*\)/\1 \2/p' "$HOME/.Xdefaults" | awk '{printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi
# }}}

# {{{ Completion
    # Remove pwd after doing ../
    zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd

    # Don't keep suggesting file / pid if it is on the line already
    zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

    # More processes in kill completion
    zstyle ':completion:*:processes' command 'ps --forest -A -o pid,user,cmd'

    # There's lots of bad hosts in /etc/hosts with IP 0.0.0.0. These should not be in completion
    hosts=( $(( awk 'BEGIN {OFS="\n"} /^[^#0]/ {for (i=2;i<=NF;i++) print $i}' /etc/hosts ) | grep -v '\.localdomain$' | sort -u) )
    hosts+=( $(sed -n 's/[ 	]*Host[ 	]\{1,\}\([^ 	*$]*\).*/\1/p' ~/.ssh/config))
    zstyle ':completion:*' hosts $hosts

    # Less users
    users=(henrik root)
    zstyle ':completion:*' users $users

    # Use menu by default
    zstyle ':completion:*' menu select

    # Tab completion for .. et al
    zstyle ':completion:*' special-dirs true

# }}}

# {{{ Prompts
local ps1_col_prompt=${fg[yellow]} ps1_col_error=${fg[red]} ps1_host=""
[[ $UID -eq 0 ]] && ps1_col_prompt=${fg[red]} && ps1_col_error=${fg[red]}
[[ -n $SSH_TTY ]] && ps1_host="@$HOSTNAME "

PS1="%{$ps1_col_prompt%}$ps1_host%~ %(?..%{$ps1_col_error%}(%?%) )%{$reset_color%}$ "
PS2="%_> "
PS4="%N (%i)> "

unset ps1_col_prompt ps1_col_error

# Use the prompt also as term title
# Must keep $ps1_host fo work as expected
case $TERM in
    xterm*|rxvt*|(K|a)term)
        function precmd {
            print -Pn "\e]0;$ps1_host%~ %(?..(%?%) )$ \a"
        }

        function preexec {
            print -Pn "\e]0;$ps1_host%~ %(?..(%?%) )$ $1\a"
        }
        ;;
esac

# }}}

# {{{ History
HISTSIZE=1000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt BANG_HIST
# }}}

# {{{ Aliases
if [[ $OSTYPE =~ "linux*" ]]; then
    alias ls="ls --color='always' --group-directories-first"
fi
alias bc="bc -l"
alias c="cd .."
export GREP_COLORS="1;33"
alias glances="glances --theme-white"
alias grep="grep --color=auto"
alias history="history -Df"
alias impressive="impressive -G 1"
alias l=ls
alias mysql="mysql --sigint-ignore"
alias repkg="makepkg -efi"
alias rm="rm --preserve-root"
alias startx="exec xinit"
alias vi="vim -p"
alias vim="vim -p"
alias webshare="python2 -m SimpleHTTPServer"

# No zsh glob expansion for these commands
alias find="noglob find"

# Tixi
alias n="tixi -s -e"
alias i="tixi -s -i"

# Git
alias g="git status"
alias gb="git branch"
alias gd="git diff"
alias gdw="git diff --word-diff"
alias gdc="git diff --cached"
alias gdcw="git diff --cached --word-diff"
alias gg="git log --graph --decorate"

# }}}

# ## Functions {{{
# Open files using xdg-open
# If no arguments, open the first file in $PWD
function o {
    [[ -z $1 ]] && 1=$(ls -1 --color=never|head -n 1)

    while [[ -n $1 ]]; do
        xdg-open "$1"
        shift
    done
}

# Make directories, cd into the first one
function md {
    mkdir -p "$@" && cd "$1"

}

# calculate expression
function calc {
    echo "$@" | bc -l
}


# Recursively execute git command in git roots from $PWD
# Example: $ gitrec push
function gitrec {
    local repo
    for repo in **/.git; do
        (echo "--- ${repo:h} ---"; cd ${repo:h}; git "$@"; echo)
    done
}

# Run $1 when $2+ is written, forever. Used to e.g. auto reload when coding
# Usage:
#    $ onwrite script.py "python script.py" *.py
#
# Adapted from http://stackoverflow.com/a/10670583
function onwrite {
    which inotifywait || return;
    cmd="$1"
    shift

    while true; do
        clear
        echo "---------- $(date) ----------"
        eval "$cmd &!"
        trap "kill $!&> /dev/null; return;" SIGINT SIGTERM
        inotifywait -e modify -qq "$@"
        kill $! &> /dev/null
    done
}

function apt-history {
    case "$1" in
    install)
        cat /var/log/dpkg.log | grep 'install ' ;;
    upgrade|remove)
        cat /var/log/dpkg.log | grep $1 ;;
    rollback)
        cat /var/log/dpkg.log | grep upgrade | \
        grep "$2" -A10000000 | \
        grep "$3" -B10000000 | \
        awk '{print $4"="$5}';;
    *)
        cat /var/log/dpkg.log ;;
    esac
}
# }}}

# ### cd improvements {{{
# Use pushd to preserve history. `cdm` displays a menu of previous dirs,
# Adapted from Pro Bash Programming - ISBN 978-1430219989

# cd with history - i.e. pushd
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
export DIRSTACKSIZE=10

# cd by menu, with previous directories as options
function cdm {
    #echo
    select i in $(dirs -p | tail -n +2); do
        if [[ -n "$i" ]]; then
            cd "${i//\~/$HOME}"
            return $?
        fi
    done
}
# }}}
