export PATH=$HOME/.bin:$PATH

# Check for an interactive session
[ -z "$PS1" ] && return

# bash-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    complete -cf sudo
fi

# Prompt
build_ps1() {
    local prompt_color='\e[1;33m\]'
    local host=''
    [[ $UID -eq 0 ]] && prompt_color='\e[1;31m'
    [[ $SSH_TTY ]] && host="@$HOSTNAME "
    echo "${prompt_color}${host}\w\[\033[0m\] \$ "
}
PS1=$(build_ps1)
PS2='\\ '

# shell options
shopt -s cdspell
shopt -s checkwinsize
shopt -s dotglob
shopt -s extglob
shopt -s globstar

# Share history between sessions
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"
export HISTSIZE=10000

# More helpful cd
export CDPATH=".:$HOME"

# Add some color
alias ls='ls --color=auto'
export GREP_COLOR="1;33"
alias grep='grep --color=auto'

# Other aliases
alias c="cd .."
alias cal="cal -m"
alias o="xdg-open"
alias rm="rm --preserve-root"
alias repkg="makepkg -efi"

# Exports
export AWT_TOOLKIT=MToolkit
export BROWSER="chromium"
export EDITOR="vim"
export OOO_FORCE_DESKTOP=gnome

# Useful functions
function p {
# Packer / pacman wrapper. Packer does what it can, passes on to
# pacman if needed.
    packer $*
    [[ $? -eq 5 ]] && pacman $*
}
