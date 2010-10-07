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
    [[ ! -z $SSH_TTY ]] && host="@$HOSTNAME "
    echo "${prompt_color}${host}\w\[\033[0m\] \$ "
}
# Prompt
PS1=$(build_ps1)
PS2='\\ '

# shell options
shopt -s cdspell
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
alias y='yaourt'
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
extract () {
    if [ -f $1 ] ; then
	case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       rar x $1       ;;
           *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
	echo "'$1' is not a valid file!"
   fi
 }

 convert_video() {
     # convert_video xxx.mts xxx.avi
     ffmpeg -i $1 -copyts -sameq -target ntsc-dvd $2 
}     
 
repkg() {
    makepkg -efi
}

calc(){ 
	echo "$*" | bc;
}

# Make files or directories belong to me
function mkmine() { sudo chown -R ${USER}:${USER} ${1:-.}; }
