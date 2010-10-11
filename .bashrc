export PATH=$HOME/.bin:$PATH

# Check for an interactive session
[ -z "$PS1" ] && return

# Start X if logging in from vc/1
#if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
	#xinit -- :0
	#logout
#fi

# bash-completion
complete -cf sudo
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


build_ps1() {
    local prompt_color='\e[1;33m\]'
    local host=''
    [[ $UID -eq 0 ]] && prompt_color='\e[1;31m'
    [[ $SSH_TTY ]] && host="@$HOSTNAME "
    echo "${prompt_color}${host}\w\[\033[0m\] \$ "
}
# Prompt
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
alias pacman='sudo pacman'
alias rm="rm --preserve-root"
alias emacs="emacs -nw"
alias c="cd .."
alias e3="e3vi"

alias o="xdg-open"
alias cal="cal -m"

alias screenon="sudo vbetool dpms on"
alias screenoff="sudo vbetool dpms off"

# Exports
export BROWSER="chromium"
export EDITOR="vim"
export OOO_FORCE_DESKTOP=gnome
export AWT_TOOLKIT=MToolkit

# Useful functions
function p {
# Packer / pacman wrapper. Packer does what it can, passes on to
# pacman if needed.
    packer $*
    [[ $? -eq 5 ]] && pacman $*
}

repkg() {
    makepkg -efi
}

calc(){ 
	echo "$*" | bc;
}

# Make files or directories belong to me
function mkmine() { sudo chown -R ${USER}:${USER} ${1:-.}; }
