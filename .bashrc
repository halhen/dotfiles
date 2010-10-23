# #~/.bashrc

# This is my configuration for bash. I hope to keep it useful across
# the computers I use, without depending on bash for my custom
# functions if I need them from the outside.

# ## Basics {{{
# Include `$HOME/.bin` in `$PATH`.
export PATH=$HOME/.bin:$PATH

# Stop executing if this is not an interactive session.
[ -z "$PS1" ] && return

# }}}

# ## Command entry {{{
# Use [bash completion](http://freshmeat.net/projects/bashcompletion), also with sudo completion.
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    complete -cf sudo
fi

# Set prompt.
# `root` has a red prompt, others a yellow one.
# If we are connected remotely, `@<hostname>` shows first.
build_ps1() {
    local prompt_color='\[\e[33m\]'
    local host=''
    [[ $UID -eq 0 ]] && prompt_color='\[\e[1;31m\]'
    [[ $SSH_TTY ]] && host="@$HOSTNAME "
    echo "${prompt_color}${host}\w\[\e[0m\] \$ "
}
PS1=$(build_ps1)
PS2='\\ '

# }}}

# ## Shell options {{{
# Correct minor spelling error when `cd`.
shopt -s cdspell

# Check and update window size after each command.
shopt -s checkwinsize

# Include files beginnig with . when using globs.
shopt -s dotglob

# Enable extended globbing:
#
# * `?(pattern-list)` matches zero or one occurance of patterns
# * `*(pattern-list)` matches zero or more occurances of patterns
# * `+(pattern-list)` matches one or more occurances of patterns
# * `@(pattern-list)` matches one of the given patterns
# * `!(pattern-list)` matches anything but the patterns
#
# (Don't get too excited here, `find` is your friend)
shopt -s extglob

# Enable `**/*` for recursive globbing.
shopt -s globstar

# ##Share history between sessions
#
# By appending to, and reading from, the history file after each command,
# command history will be shared between bash instances.
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"
export HISTSIZE=10000

# }}}

# ## Exports {{{
# Java needs this to behave on e.g. [dwm](http://dwm.suckless.org).
export AWT_TOOLKIT=MToolkit

# [jumanji](http://pwmt.org/projects/jumanji) is the default browser.
export BROWSER="jumanji"

# [vim](http://www.vim.org) is the default editor.
export EDITOR="vim"

# Run OpenOffice in GTK2 mode.
export OOO_FORCE_DESKTOP=gnome

# Speed up firefox.
export MOZ_DISABLE_PANGO=1

# }}}

# ## Aliases {{{
# Colorize `ls`.
alias ls='ls --color=auto'

# Colorize `grep`.
export GREP_COLORS="1;33"
alias grep='grep --color=auto'

# Convenient `cd..`.
alias c="cd .."

# Convenient `xdg-open`.
alias o="xdg-open"

# Never `rm` `/`.
alias rm="rm --preserve-root"

# Display Monday as first day of week in `cal`.
alias cal="cal -m"

# Remake a `PKGBUILD` in the current directory.
alias repkg="makepkg -efi"

# Defaults for bc
alias bc="bc -l"

# Open multiple files as tabs.
alias vim="vim -p"

#}}}

# ## Functions {{{
# [Packer](http://wiki.archlinux.org/index.php/AUR_Helper#packer) / pacman wrapper.
# First tries `packer`, which tells us if it won't handle the command.
# If `packer` fails, let `pacman` do the job.
function p {
    packer --noconfirm --noedit $*
    [[ $? -eq 5 ]] && pacman $*
}

# Make directories, cd into the first one
function md {
    mkdir -p "$@" && cd "$1"

}

# calculate expression
function calc {
    echo "$@" | bc -l
}


# Search man pages for user commands
function k {
    man -k "$@" | grep '(1' --color=never
}

# ### cd improvements {{{
# Use pushd/popd to preserve history, and use helpers `pd` for previous dir
# and `cdm` to display a menu of previous dirs,
# Taken from Pro Bash Programming - ISBN 978-1430219989

# cd with history - i.e. pushd
function cd {
    local dir error
    
    while :; do # No support for options, consume them
        case $1 in
            --) break ;;
            -*) shift ;;
            *) break ;;
        esac
    done

    dir=${1:-$HOME}

    pushd "$dir" 2>/dev/null
    error=$?

    [[ $error != 0 ]] && builtin cd "$dir"
    return "$error"
} >/dev/null

# Previous directory
function pd {
    popd
} >/dev/null

# Menu function
function _menu {
    local IFS=$' \n\t'
    local num n=1 opt="" item cmd
    echo

    for item; do
        printf "  %3d, %s\n" "$n" "${item%%:*}"
        n=$(( n + 1 ))
    done
    echo

    # Accept single digit press if possible
    [[ $# -lt 10 ]] && opt=-sn1
    read -p " (1 to $#) ==> " $opt num
    echo

    case $num in 
        [qQ0] | "" ) return ;;
        *[!0-9]* | 0* ) printf "Invalid response: %s\n" "$num" >&2; return 1;;
    esac

    [ "$num" -gt "$#" ] && printf "Invalid response: %s\n" "$num" >&2 && return 1;

    eval "${!num#*:}"
}
# cd by menu, with previous directories as options
function cdm {
    local dir IFS=$'\n' item
    for dir in $(dirs -p); do
        fulldir=${dir//\~/$HOME}
        [[ "$fulldir" = "$PWD" ]] && continue
        case ${item[*]} in
            *"$dir:"*) ;;
            *) item+=( "$dir:cd '$fulldir'" );;
        esac
    done
    _menu "${item[@]}"

}

# }}}
# }}}
