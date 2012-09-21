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

# Non-interactive mode
[ -z "$PS1" ] && return

# stalker: purple - slacker: bordeaux - kollok: orange
if [[ -z $L_PS1_ALREADY_SET ]]; then
    if [[ -n $SSH_CLIENT ]]; then export _P_SSH=" (ssh)" ; fi
    PS1='\[\033[38;5;63m\]$(__git_ps1 "(%s) ")\[\033[38;5;${L_PS1_HOST_COLOR}m\]\u:\[\033[00m\]\[\033[38;5;166m\]$(date +%H:%M)\[\033[01;34m\]${_P_SSH} \w \[\033[00m\]'
fi


###############################
#        VERY TEMPORARY       #
###############################

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
export HISTFILESIZE=10000
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

alias cdms='cd ~/Media/series'
alias cdmf='cd ~/Media/flims_new'
alias cdma='cd ~/Media/animes'
alias cdmm='cd ~/Media/music_new'

# Git bookmarks begin with cdg
alias cdgd='cd ~/git/perso_dotfiles'

#
# THESE ARE FIXED FOREVER
#

# Listing-related
alias ls='ls --color=auto'
alias sl='ls'
alias l='ls'
alias ll='ls -ahl'
alias lt='ls -lrth'
alias lat='ls -larth'
alias lsdir='ls -p | grep "/$"'

lsln() { ls "$1" -la |grep " \-> " ; }
alias lshln='ls ~/ -la |grep "\->"'

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
function ,, () {
    cd ..
}

# Utilities (grep, basename, dirname)
alias g='grep -nr --color'
alias gi='grep -nri --color'
alias gr='grep -nr --color'
alias gri='grep -nri --color'
alias bn='basename'
alias dn='dirname'

# Find
f () {
    name="$1" ; shift
    if [[ $# -eq 0 ]] ; then
	echo zero
	find . -name '*'"$name"'*'
    else
	find . -name '*'"$name"'*' "$@"
    fi
}

# Disk use sorted, process list
alias dus="du -sh * .* | sort -k1,1h"
alias psa='ps aux | grep'
alias pst='pstree -hAcpul'

# Rsync - Unison
alias unison='unison -ui text'
alias unipart='unison config_part.prf'
alias unifull='unison config_full.prf'

# syncd for sync-delete (to avoir a deadly typo)
alias syncd="rsync      -aSHAXh  --rsh=ssh --delete"
alias syncdv="rsync     -aSHAXh  --rsh=ssh --delete --progress --stats"
alias syncdnv="rsync    -aSHAXh  --rsh=ssh --delete --progress --stats --numeric-ids"
alias syncdbw80="rsync  -aSHAXh  --rsh=ssh --delete --progress --stats --numeric-ids --bwlimit=80"
alias syncdbw800="rsync -aSHAXh  --rsh=ssh --delete --progress --stats --numeric-ids --bwlimit=800"


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
alias vimbs="e ~/.bashrc_stalker"
alias vimbl="e ~/.bashrc_linux"
alias vimbg="e ~/.bashrc_gamer"
alias vimbk="e ~/.bashrc_kollok"
alias sob='source ~/.bashrc'
alias vimz="e ~/.zshrc"
alias soz="source ~/.zshrc"
alias vimv="e ~/.vimrc"

# Add absolute symbolic link
lna() {
    if [ -z "$1" -o "$#" -gt 2 ] ; then
	echo "usage: lna [file] [destination]"
	echo " Creates an absolute symbolic link from relative file pointing to dest"
    else
	ln -s $(pwd)/"$1" "$2"
    fi
}
alias add_to_bin_shared='ln -s -t ~/bin/shared/'
alias add_to_bin_local='ln -s -t ~/bin/local/'

# Patch / merge - rudimentary
function merge-rej () {
    for i in "$@"; do
	e -d "$i" "b/$i.rej"
    done
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


## Works, but to extend!
##
##
#rsync -avub --progress --delete Pictures gamer:Media/mac_pictures/Pictures
##
##
## Works, but to extend!


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

# WXPython
alias wxdemo='python /usr/src/python_libs/wxPython-2.8.8.1/demo/Main.py'

# Django
alias djvim='~/scripts/shared/vim_djvim.sh' # Launch vim with right paths for django
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

## SSH AGENT
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
fi


#
# BACKUP STUFF - Unison and Rsync
#
# In respective bashrcs

#
# My MOTS (Message Of The Session)
#
case $(hostname) in
    kollok|stalker|slacker|gamer)
        break;;
    *)
        return;
        break;;
esac

echo "--"
# Display random task if 1/ task present and 2/ task count > 0 (the export LC_ALL is for sort)
tput setf 4 ; command -v task &>/dev/null && ( export LC_ALL='C' ; [ $(task count) -gt 0 ] && task | head -n -2 | tail -n -2 | sort -R | head -1 )
# Display a random alias (so that I think about using them :) )
echo -n " " ; tput setaf 2 ; alias | sort -R | head -1
tput sgr0
echo "--"


#vim:foldmethod:marker
