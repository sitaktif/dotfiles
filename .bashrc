###############################
#      SYSTEM SPECIFIC        #
###############################

# Default values defined in system-specific rc-files - "L_" for "LOCAL"
[ -z "$(which vim)" ] && export L_VIM="vi" || export L_VIM="vim"

export L_PS1_HOST_COLOR="46" # Green by default
export L_PS1_ALREADY_SET=""

# Load OS-specific rc files
#
if [[ "$(uname)" == 'Darwin' ]]; then # Leopard
    source ~/.bashrc_mac
elif [[ "$(uname)" == 'Linux' ]]; then # Linux (slacker / kollok)
    source ~/.bashrc_linux
fi

if [[ -e ~/.bashrc_misc ]]; then
    source ~/.bashrc_misc
fi

# Non-interactive mode
[ -z "$PS1" ] && return


function __prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1=""

    local C_RST='\[\e[0m\]'
    local C_RED='\[\e[0;31m\]'
    local C_BLUE='\[\e[01;34m\]'
    local C_USER='\[\e[38;5;${L_PS1_HOST_COLOR}m\]'
    local C_DATE='\[\e[38;5;166m\]'
    local C_GIT='\[\e[38;5;63m\]'

    local PS_EXIT=''
    if [ $EXIT != 0 ]; then
        PS_EXIT="${C_RED}[$EXIT]${C_RST} "      # Add red if exit code non 0
    fi

    PS1+="${C_GIT}$(__git_ps1 "(%s) ")${C_USER}\u:${C_RST}${C_DATE}$(date +%H:%M)${C_BLUE}${_P_SSH} ${PS_EXIT}${C_BLUE}\w ${C_RST}"
}

# stalker: purple - slacker: bordeaux - kollok: orange - blinker: 'skin'
if [[ -z $L_PS1_ALREADY_SET ]]; then
    if [[ -n $SSH_CLIENT ]]; then export _P_SSH=" (ssh)" ; fi
    export PROMPT_COMMAND=__prompt_command  # Func to gen PS1 after CMDs
fi


###############################
#        VERY TEMPORARY       #
###############################

alias cdgc='cd ~/git/config'

togit() {
    mv "$@" ~/git/perso_dotfiles/ && ln -s ~/git/perso_dotfiles/"$@" ./
}


###############################
#          OPTIONS            #
###############################

# Make extended globs work
shopt -s extglob

# Binaries in home
export PATH=~/bin/local:~/bin:~/bin/scripts:$PATH

# General
export EDITOR=vim
export VISUAL=vim

# Works for Mac - does it for others?
eval $(dircolors ~/.dircolors)

# Bash
export HISTCONTROL=ignoredups
export HISTFILESIZE=100000
export HISTSIZE=10000

# Rsync and others transfer apps
export UPLOAD_BW_LIMIT=400

# App-specific
export MPD_HOST="localhost"
export TEXMFHOME="~/.texmf"
export SVN_EDITOR="vim"
#export CVSROOT=":pserver:any@server:abs_path"

if [ -f "$HOME/.dircolors" ] ; then
    eval $(dircolors -b "$HOME/.dircolors")
fi


###############################
#           ALIASES           #
###############################

# Summary: cd, ls, t[a] (tree), mkcd, ,, (cd ..), e (edit), f, g gi gr gri (grep), lna, sr, sls

## Bookmarks
alias cdjf='cd ~/git/site_espira/jf'
alias cdj2='cd ~/git/site_chinafrique/src'
alias cdjj='cd ~/sites/jj/code'
alias cdts='cd ~/git/ts.git/src'
alias cdsp='cd ~/git/site_sportsclub/sportsclub/club'
alias cdts='cd ~/git/ts/src'


alias cdms='cd ~/Media/series'
alias cdmf='cd ~/Media/films'
alias cdma='cd ~/Media/animes'
alias cdmm='cd ~/Media/music_new'

# Git bookmarks begin with cdg
alias cdgd='cd ~/git/perso_dotfiles'

#
# THESE ARE FIXED FOREVER
#

# gradle
GRA() { # Run gradle if found in the current or parent directories
    for i in . .. ../.. ../../.. ../../../..; do
        if [[ -x $i/gradlew ]]; then
            (cd $i && ./gradlew "$@") ; return
        fi
    done
    echo "No gradlew found in current or parent directories"
}

# git
alias gg='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gr='git remote'
alias gd='git diff'
alias gdc='git diff --cached'
alias gra='git remote add'
alias grr='git remote rm'
alias grv='git remote -v'

# Listing-related
alias ls='ls --color=auto'
alias sl='ls'
alias l='ls'
alias ll='ls -ahl'
alias lt='ls -lrt'

lsd() { ls -F "$@" |grep "/$" ; }
lsl()  { ls -F "$@" |grep "@$" ; }
lsx()   { ls -F "$@" |grep "\\*$" ; }

# Tree (particularly useful for django)
alias ta='tree    --charset ascii -a        -I \.git*\|*\.\~*\|*\.pyc'
alias ta2='tree   --charset ascii -a  -L 2  -I \.git*\|*\.\~*\|*\.pyc'
alias ta3='tree   --charset ascii -a  -L 3  -I \.git*\|*\.\~*\|*\.pyc'
alias tA='tree    --charset ascii -a'
alias tap='tree   --charset ascii -ap       -I \.git*\|*\.\~*\|*\.pyc'
alias td='tree    --charset ascii -d        -I \.git*\|*\.\~*\|*\.pyc'
alias tad='tree   --charset ascii -ad       -I \.git*\|*\.\~*\|*\.pyc'
alias tad2='tree  --charset ascii -ad -L 2  -I \.git*\|*\.\~*\|*\.pyc'
alias tad3='tree  --charset ascii -ad -L 3  -I \.git*\|*\.\~*\|*\.pyc'
alias tas='tree   --charset ascii -ash      -I \.git*\|*\.\~*\|*\.pyc'
alias tug='tree   --charset ascii -aug      -I \.git*\|*\.\~*\|*\.pyc'
alias taj='tree   --charset ascii -a        -I \.git*\|*\.\~*\|*\.pyc\|__init__\.py'

alias pud='pushd -n "$args" &> /dev/null' # Push dir on stack
alias pod='popd >& /dev/null'		 # Go back in time
alias ds="dirs -v"       # Show DIRSTACK with array index

# Directory change functions
mkcd () {
    mkdir -p "$*" ; cd "$*"
}

function , ()    { cd .. ; }
function ,, ()   { cd ../.. ; }
function ,,, ()  { cd ../../.. ; }
function ,,,, () { cd ../../../.. ; }

# Utilities (grep, basename, dirname)
alias grep='grep --color'
alias gri='grep -rI'

# Find
f() {
    name="$1" ; shift
    find . -name '*'"$name"'*' "$@"
}
fl() {
    name="$1" ; shift
    find -L . -name '*'"$name"'*' "$@"
}

# Disk use sorted, process list
alias dus="du -sh * .* | sort -k1,1h"
alias psa='ps aux | grep'
alias pst='pstree -hAcpul'

# Rsync - Unison
alias unison='unison -ui text'
alias unismall='unison small_data'
alias unibig='unison big_data'
alias unifull='unismall && unibig'

# Taskwarrior
alias t='task'

# Screen
alias sls='screen -ls'
alias sr='screen -r'

# Handy prefixes
alias left='DISPLAY=:0.0'
alias right='DISPLAY=:0.1'

# Improved man - tries python doc
function man () {
(   /usr/bin/man "$@" ||
    python -c "
try:
    help($1)
except NameError:
     locals()['$1']=__import__('$1')
     help('$1')" ||
    echo "No manual entry or python module for $1" ) 2>/dev/null
}

# Editor related
alias e="$L_VIM"

# Bash, zsh, vim
alias vimb="e ~/.bashrc"
alias sob='source ~/.bashrc'
alias vimbs="e ~/.bashrc_stalker"
alias vimbl="e ~/.bashrc_linux"
alias vimbg="e ~/.bashrc_slacker"
alias vimbk="e ~/.bashrc_kollok"
alias vimz="e ~/.zshrc"
alias soz="source ~/.zshrc"
alias vimv="e ~/.vimrc"

# Add absolute symbolic link
lna() {
    if [ -z "$1" -o "$#" -gt 2 ] ; then
	echo "usage: lna [file] [destination]"
	echo " Creates an absolute symbolic link from relative file pointing to dest"
    else
        ln -s "$(readlink -f "$(pwd)/$1")" "$2"
    fi
}


############################
#        BOOKMARKS         #
############################

# SSH
alias k='ssh sitaktif@kollok.org'
alias k2='ssh sitaktif@uk.kollok.org -p443'
alias sshs='ssh stalker'
alias sshg='ssh gamer'
alias sshm='ssh mickey'
alias sshp='ssh chossart2006@perso.iiens.net'
alias sshp2='ssh -p 443 chossart2006@perso.iiens.net'
alias sshr='ssh -l rchossart'
alias ssha='ssh rchossart@theisland.acunu.com' # Ssh Acunu VPN

# Lftp
alias jjftp='lftp jeanjolly@ftp4.phpnet.org'

# MPD
alias mpds="mpd --no-daemon &"
alias mpdk="mpd --kill"
alias mpdr="mpdk && mpds"

# AndroiD
alias adencode='~/scripts/android/encode_to_mp4.sh low'

# Other
alias vless='vim -u /usr/share/vim/vim72/macros/less.vim'
alias myports='netstat -alpe --ip'

# Irssi
#alias pirssi='killall irssi_notify_daemon && irssi_notify_daemon & luit -encoding iso8859-15 ssh chossart2006@perso.iiens.net'

## Python {{{
alias tip='touch __init__.py'

# Django
alias vimdjango="$L_VIM ../{urls,settings}.py models.py views/*.py forms/*.py templates/*.py"
alias drs='python manage.py runserver'
alias dsd='python manage.py syncdb'
alias dsh='python manage.py shell'
#}}}
## Old {{{

# PEC
#alias ssh_pec='ssh pecprod@thepec.net'
#alias pec_start='cd pec && python manage.py runserver 0.0.0.0:8000'
#alias pecdb='mysql -D test -u root -p'

#}}}

## SSH AGENT - use keychain to prompt at login (requires the package..)
#SSHAGENT=/usr/bin/ssh-agent
#SSHAGENTARGS="-s"
#if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
#    echo sshagent
#    eval `$SSHAGENT $SSHAGENTARGS`
#    trap "kill $SSH_AGENT_PID" 0
#fi
if [ -n "$TERM" ] && [ -x "$(which keychain)" ] && \
    [ -f "$HOME/.ssh/id_rsa" ] ; then
    keychain -q $HOME/.ssh/id_rsa
    . $HOME/.keychain/$(hostname)-sh
fi


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#vim:foldmethod:marker
