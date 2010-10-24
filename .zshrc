# TODO: Remove 0.0.0.0 adresses at host comppletion
# TODO: Get inspired by other .zshrc:s
# TODO: Is ~/.bin added everywhere it should?

autoload -U compinit && compinit
autoload -U colors && colors

# {{{ Exports
typeset -U path
path=( ~/.bin $path)

export AWT_TOOLKIT=MToolkit
export BROWSER="jumanji"
export EDITOR="vim"
export PAGER="less"
export OOO_FORCE_DESKTOP="gnome"
export MOZ_DISABLE_PANGO=1
export HOSTNAME=$(hostname)
# }}}

# {{{ Shell options
setopt CHECK_JOBS
setopt CORRECT
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt SHORT_LOOPS

bindkey -v
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# }}}

# {{{ Completion
    # Remove pwd after doing ../
    zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd
    # Don't keep suggesting file / pid if it is on the line already
    zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
    # More processes in kill completion
    zstyle ':completion:*:processes' command 'ps -au$USER'
    # There's lots of bad hosts in /etc/hosts with IP 0.0.0.0. These should not be in completion
    zstyle ':completion:*' hosts $(awk '/^[^#0]/ {print $2, $3, $4, $5}' /etc/hosts)
# }}}

# {{{ Prompts
local ps1_col_prompt=${fg[yellow]} ps1_col_error=${fg[red]} ps1_host=""
[[ $UID -eq 0 ]] && ps1_col_prompt=${fg[red]} && ps1_col_error=${fg[red]}
[[ -n $SSH_TTY ]] && ps1_host="@$HOSTNAME "

PS1="%{$ps1_col_prompt%}$ps1_host%~ %(?..%{$ps1_col_error%}(%?%) )%{$reset_color%}$ "
PS2="%_> "
PS4="%N (%i)> "

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
alias ls="ls --color=always"
alias less="less -R"
export GREP_COLORS="1;33"
alias grep="grep --color=auto"
alias c="cd .."
alias o="xdg-open"
alias rm="rm --preserve-root"
alias cal="cal -m"
alias repkg="makepkg -efi"
alias bc="bc -l"
alias vim="vim -p"
alias history="history -Df"

# }}}

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
# Use pushd to preserve history. `cdm` displays a menu of previous dirs,
# Adapted from Pro Bash Programming - ISBN 978-1430219989

# cd with history - i.e. pushd
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# cd by menu, with previous directories as options
function cdm {
    local IFS=$'\n'
    dirhist=( $(dirs -p | tail -n +2 | head) )

    [[ -z "${dirhist[@]}" ]] && return
    echo 
    select i in "${dirhist[@]}"; do
        if [[ -n "$i" ]]; then
            cd "${i//\~/$HOME}" 
            return $?
        fi
    done
}
# }}}
# }}}