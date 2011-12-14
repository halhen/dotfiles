# vim:ft=sh

autoload -U compinit && compinit
autoload -U colors && colors

# {{{ Exports
typeset -U path
path=( ~/.bin $path)

export AWT_TOOLKIT=MToolkit
export BROWSER="firefox"
export EDITOR="vim"
export PAGER="less"
export OOO_FORCE_DESKTOP="gnome"
export MOZ_DISABLE_PANGO=1
export HOSTNAME=$(uname -n)
export PYTHONSTARTUP=$HOME/.pythonrc

find /usr/share/terminfo -name "$TERM" | grep -q "$TERM" || export TERM=rxvt-256color
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
# Bindings for urxvt
# Arrow up/down
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Home/end
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line

# ^E to edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# ^L to pipe through $PAGER and execute
bindkey -s '^L' "|$PAGER\n"

# color STDERR red
exec 2>>(while read line; do
            print ${fg[red]}${(q)line}$resetcolor > /dev/tty;
            print -n $'\0';
         done &)
# }}}

# {{{ Colors for console

# Use the settings for urxvt from ~/.Xdefaults
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

    # clyde is pacman
    compdef _pacman clyde=pacman

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
    alias ls="ls --color=always"
fi
alias bc="bc -l"
alias c="cd .."
export GREP_COLORS="1;33"
alias grep="grep --color=auto"
alias history="history -Df"
alias impressive="impressive -G 1"
alias l=ls
alias less="less -FiMRsX"
alias repkg="makepkg -efi"
alias rm="rm --preserve-root"
alias startx="exec xinit"
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
