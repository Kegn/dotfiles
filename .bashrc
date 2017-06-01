## Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

## User exports
export EDITOR=vim
#do not log duplicate commands.
export HISTCONTROL=ignoredups
#PS1="\[\e[0;33m\][\u@\h \[\e[0;34m\]\W\[\e[0;33m]\]\[\e[0;31m\]\$\[\e[m\] "
export PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\[$(tput setaf 7)\]\u\[$(tput setaf 6)\]@\[$(tput setaf 5)\]\h \[$(tput setaf 6)\]\W\[$(tput setaf 2)\]]\[$(tput setaf 6)\]\\$ \[$(tput sgr0)\]"

#colorscheme
source "${HOME}/.cache/wal/colors.sh"

#colors
black() { echo "$(tput setaf 0)$*$(tput setaf 9)"; }
red() { echo "$(tput setaf 1)$*$(tput setaf 9)"; }
green() { echo "$(tput setaf 2)$*$(tput setaf 9)"; }
yellow() { echo "$(tput setaf 3)$*$(tput setaf 9)"; }
blue() { echo "$(tput setaf 4)$*$(tput setaf 9)"; }
magenta() { echo "$(tput setaf 5)$*$(tput setaf 9)"; }
cyan() { echo "$(tput setaf 6)$*$(tput setaf 9)"; }
white() { echo "$(tput setaf 7)$*$(tput setaf 9)"; }

## User specific functions

#colorized man pages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}


rot13 () {              # rot13 everywhere
        if [ $# -eq 0 ]; then
                tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
        else
                #echo "hi"
		echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
        fi
}

#generates $6$ encrypted passwords for /etc/shadow
sha512salter () {
        python3 -c 'import crypt; print(crypt.crypt("$1",
crypt.mksalt(crypt.METHOD_SHA512)))'
}


#backs up current file, writes backup record to log
bu() {
	cp $@ $@.backup-`date +%y%m%d`;echo "`date +%Y-%m-%d` backed up $PWD/$@" >> ~/.logs/backup.log;
}

#moves n directories up
up() {
    dir=""
    if [[ $1 =~ ^[0-9]+$ ]]; then
        x=0
        while [ $x -lt ${1:-1} ]; do
            dir=${dir}../
            x=$(($x+1))
        done
    else
         dir=..
    fi
    cd "$dir";
}

#prepends text to file.
#usage: prepend "text" myfile
prepend ()
{
    echo -e "$1\n$(cat $2)" > $2
}

#rcfn outputs function type as comment + definition
#combine with prepend to add functions to beginning of ~/.bashrc
rcfn ()
{
    echo "#$(type $1)"
}


## user defined aliases
#bin mod-aliases
alias top='htop'
alias urxvt='urxvt -tr -sh 20'
alias vi='vim'
alias traceroute='traceroute -I'
alias wget='wget -c'
alias top='atop'
alias mkdir='mkdir -pv'

#device action aliases
alias akete="eject /dev/sr1"
alias shimeru="eject -t /dev/sr1"


#web aliases
alias ogmail="xdg-open https://mail.google.com"

#mnemonic aliases
alias hg='history | grep'
alias lss='/bin/ls --color=auto -CFX'
alias rebash="source ~/.bashrc"
alias mkdir='mkdir -pv'
alias path='echo -e ${PATH//:/\\n}'
alias vis='vim "+set si"'
alias fastping='ping -c 100 -s.2'
alias vlcp='vlc *.avi'
alias pscpu='ps auxf | sort -nr -k 4 | head -10'
alias pscpu10='ps auxf | sort -nr -k 4 | head -10'
alias pubip="echo $(GET icanhazip.com)"
alias cpr='rsync --progress -ravz'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias duf="du -h | awk 'END{print $1}'"
alias dud='du -h --max-depth=1 | sort -rh'
alias clean-typescript="cat $1  | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > $2"
