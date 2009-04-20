# Check for an interactive session
[ -z "$PS1" ] && return

# Start X if logging in from vc/1
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/vc/1 ]]; then
	xinit -- :0
	logout
fi

# bash-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Prompt
PS1='\[\e[1;33m\][\!]\[\e[m\]\[\e[0;37m\][\u \w]\[\e[m\]\[\e[m\] \[\e[1;33m\]\$ \[\e[m\]\[\e[0;37m\]'

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

# Exports
export EDITOR="vim"
export OOO_FORCE_DESKTOP=gnome

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

# Play a random radio station from shoutcast. Optionally add arguments, r.g. 'randradio metallica'.
randradio() {
    killall mpg123 &> /dev/null; shoutcast-search -n 1 -t mpeg -b ">63" --sort=ln10r $* | xargs mpg123 -q -@ &
}

# Use dmenu to select a radio station. Optionally add arguments, e.g. 'radio metallica'.
radio() {
    killall mpg123 &> /dev/null;
    URL=`shoutcast-search -t mpeg -b ">63" --sort=l -f "[%l] %s %p %u" $* | dmenu -fn "-*-terminal-medium-r-normal-*-12-*-*-*-*-*-iso8859-1" -nb "#222222" -nf "#a8a8a8" -sb "#222222" -sf "#afc81c" | awk '{ print $NF }'` 
    if [ ! -z $URL ]; then
        nohup mpg123 -q -@ $URL &>/dev/null &
    fi
}
