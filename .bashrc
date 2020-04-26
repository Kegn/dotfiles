#!/bin/bash

alias python=python2
alias gettimezone="curl -s worldtimeapi.org/api/ip.txt | sed -n 's/^timezone: //p'"
alias ips="ip a | grep -oP '(?<=inet |addr:)(?:\d+\.){3}\d+'"
alias gpg=gpg2
alias cl='grc -s'


newline_remove() {
    printf "%s" `(cat $1) | sed -e :a -e N -e '$!ba' -e 's/\n/ /g'`
}


comp_nmap_scan() {
	nmap -n -Pn -sSU -pT:0-65535,U:0-65535 -v -A -oX $1 $2
}


newfortune_please() {
	# change current outlook
	cowsay -f "$(ls /usr/share/cows/ | sort -R | head -1)" "$(fortune -s)"
}

export PAGER="most"

printme_pi() {
	# like newfortune_please, but prints pi instead of fortune
	cowsay "$(seq -f '4/%g' 1 2 99999 | paste -sd-+ | bc -l)"
}


fixgpgagent() {
	gpg-connect-agent killagent /bye
	gpg-connect-agent killagent /bye
	gpg-connect-agent updatestartuptty /bye
}

pls_help() {
	helptext="$($1 --help)"
	echo $helptext | grep $2
}


# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

umask 022

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


alias ls='ls --color=auto'

# PATH
export PATH=$PATH:~/.local/bin/ 


##----------------------------##
##   USER-DEFINED-FUNCTIONS   ##
##----------------------------##


#CURL for AUR package build files snapshot

aursnap() {
	curl -L -O "https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz"
}

## Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\[$(tput setaf 7)\]\u\[$(tput setaf 6)\]@\[$(tput setaf 5)\]\h \[$(tput setaf 6)\]\W\[$(tput setaf 2)\]]\[$(tput setaf 6)\]\\$ \[$(tput sgr0)\]"

#colors
black() { echo "$(tput setaf 0)$*$(tput setaf 9)"; }
red() { echo "$(tput setaf 1)$*$(tput setaf 9)"; }
green() { echo "$(tput setaf 2)$*$(tput setaf 9)"; }
yellow() { echo "$(tput setaf 3)$*$(tput setaf 9)"; }
blue() { echo "$(tput setaf 4)$*$(tput setaf 9)"; }
magenta() { echo "$(tput setaf 5)$*$(tput setaf 9)"; }
cyan() { echo "$(tput setaf 6)$*$(tput setaf 9)"; }
white() { echo "$(tput setaf 7)$*$(tput setaf 9)"; }

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
alias vi='vim'
alias traceroute='traceroute -I'
alias top='htop'

#device action aliases
alias akete="eject /dev/sr1"
alias shimeru="eject -t /dev/sr1"

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
alias cpr='rsync --progress -ravz'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias duf="du -h | awk 'END{print $1}'"
alias dud='du -h --max-depth=1 | sort -rh'
#source /home/k/perl5/perlbrew/etc/bashrc
source ~/.tcpdumper.sh
#PATH="/home/k/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="/home/k/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/home/k/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/home/k/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/home/k/perl5"; export PERL_MM_OPT;

giftext(){
	# usage : giftext file.txt font.ttf
	cat $1 | convert -page A4 -density 210 -font "$2" text:- -delete 1--1 "$1.gif"
}


source ~/.bash_functions
source ~/.bash_aliases
#source ~/.bash_monitor.sh

# added by Anaconda3 installer
#export PATH="/home/k/anaconda3/bin:$PATH"
alias getnews='curl https://legiblenews.com | html2ps | ps2ascii'

# stolen from michael_leachim
  # Various, misc

  # Mirror (webcam)
alias mirror="vlc v4l2:///dev/video0"

  # Stopwatch/countdown
function stopwatch(){
    date1=`date +%s`;
     while true; do
      echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
      sleep 0.1
     done
}

function countdown(){
     date1=$((`date +%s` + $1));
     while [ "$date1" -ge `date +%s` ]; do
       echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
       sleep 0.1
     done
}
##

 # Convert video to a gif
function vid2gif(){
    ffmpeg -i $1 $1.gif
}
function sigil() {
	echo $1 | grep -o . | sort |tr -d n #| sed 's/\([A-Za-z]\)\1\+/\1/g'
}

# # # from advanced_bash_scripting_guide # # #

function fstr() # find a string in a set of files
{
    if [ "$#" -gt 2 ]; then
        echo "Usage: fstr \"pattern\" [files] "
        return;
    fi
    SMSO=$(tput smso)
    RMSO=$(tput rmso)
    find . -type f -name "${2:-*}" -print | xargs grep -sin "$1" | \
sed "s/$1/$SMSO$1$RMSO/gI"
}

# This function is roughly the same as 'killall' on linux
# but has no equivalent (that I know of) on Solaris
function killps()   # kill by process name
{
    local pid pname sig="-TERM"   # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then 
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) ; do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function ii()   # get current host related info
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
    echo
}

mcilroy() {
  tr -cs A-Za-z '\n' |
  tr A-Z a-z |
  sort |
  uniq -c |
  sort -rn |
  sed ${1}q
}

XLISPPATH=/home/k/nyquist/runtime:/home/k/nyquist/lib

alias lsof-internet="lsof -P -i -n"

largest_open_files(){
	lsof / | \
awk '{ if($7 > 1048576) print $7/1048576 "MB" " " $9 " " $1 }' | \
sort -n -u | tail | column -t
}

host_connections() {
  netstat -an | \
  grep ESTABLISHED | \
  awk '{print $5}' | \
  awk -F: '{print $1}' | \
  grep -v -e '^[[:space:]]*$' | \
  sort | uniq -c | \
  awk '{ printf("%s\t%s\t",$2,$1) ; for (i = 0; i < $1; i++) {printf("*")}; print "" }'
}

dname() {
	# returns json domain name and ip
	_dname="$1" ; curl -s "https://dns.google.com/resolve?name=${_dname}&type=A" | jq .
}

alias ducks="du -cksh *"
digup(){
	dig +short -x $1 
}

alias rework="source ~/.workrc"

# source ~/perl5/perlbrew/etc/bashrc

jpg2pdf() {
	convert -density 150 -size 1239x1754 xc:white -density 150 $1 -gravity center -composite $2
}

alias partycat="lolcat"
alias gethttpclearpw='sudo tcpdump -s 0 -A -n -l | egrep -i "POST /|pwd=|passwd=|password=|Host:"'
alias getallclearpw="sudo tcpdump port http or port ftp or port smtp or port imap or port pop3 or port telnet -l -A | egrep -i -B5 'pass=|pwd=|log=|login=|user=|username=|pw=|passw=|passwd=|password=|pass:|user:|username:|password:|login:|pass |user '"
alias dmesg="dmesg -T"
alias vcb='xclip -i -selection clipboard -o | vim -'

last24() {
# write files in home dir that have been modified in the last 24 hours to a log and std out
	find $HOME -mtime 0 | tee -a ~/.local/logs/last24/last24-home-before-$(date +Y-%m-%d).log
}
