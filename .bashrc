
# Different behavior depending on system
if [[ $(uname) == 'Darwin' ]]; then # Leopard
    if [ -z "$PS1" ]; then
	PATH=$PATH:/sw/bin # For remote git pulls
	return   # If not running interactively, don't do anything
    fi
    source ~/.bashrc_mac
fi


###############################
#        VERY TEMPORARY       #
###############################

togit() {
    mv "$@" /Users/sitaktif/git/dotfiles/ && ln -s /Users/sitaktif/git/dotfiles/"$@" ./
}


###############################
#           EXPORTS           #
###############################

#PS1='\[\033[01;34m\]\u:\[\033[00m\]\[\033[01;32m\]$(date +%H:%M)\[\033[01;34m\] \w \[\033[00m\]'
PS1='\[\033[38;5;92m\]\u:\[\033[00m\]\[\033[38;5;166m\]$(date +%H:%M)\[\033[01;34m\] \w \[\033[00m\]'

export PATH=$PATH:~/scripts/bin:~/bin/bin

# General
export MAIL=/home/sitaktif/.mail/default
export EDITOR=vim
export VISUAL=vim

# Bash
export HISTCONTROL=ignoredups
export HISTFILESIZE=10000
export HISTSIZE=10000

# App-specific
export MPD_HOST="localhost"
export TEXMFHOME="~/.texmf"
export SVN_EDITOR="vim"
#export CVSROOT=":pserver:any@server:abs_path"


###############################
#           ALIASES           #
###############################

## Bookmarks
alias cdjf='cd ~/git/site_espira/jf'
alias cdj2='cd ~/git/site_chinafrique/src'
alias cdjj='cd ~/sites/jj/code'
alias cdts='cd ~/git/ts.git/src'

#############################
# THESE ARE FIXED FOREVER ! #
#############################

# Listing-related
alias ls='ls --color=auto'
alias sl='ls'
alias l='ls'
alias ll='ls -ahl'
alias dn='dirname'

# Handy prefixes
alias left='DISPLAY=:0.0'
alias right='DISPLAY=:0.1'

# Kollok-related
alias kget='~/scripts/kollok/kget.sh'
alias kput='~/scripts/all/kput.sh'
alias ktadd="ssh kollok.org TERM=xterm /usr/local/scripts/tadd"

############################
#        BOOKMARKS         #
############################

# SSH
alias k='ssh kollok.org'
alias sshg='ssh gamer'
alias sshm='ssh mickey'
alias sshp='ssh chossart2006@perso.iiens.net'
alias sshp2='ssh -p 443 chossart2006@perso.iiens.net'

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
alias djvim='~/scripts/vim/djvim.sh' # Launch vim with right paths for django
alias cddjango='cd /sw/lib/python2.6/site-packages/django/'
alias drs='python manage.py runserver'
alias dsd='python manage.py syncdb'
#}}}
## Old {{{

# PEC
#alias ssh_pec='ssh pecprod@thepec.net'
#alias pec_start='cd pec && python manage.py runserver 0.0.0.0:8000'
#alias pecdb='mysql -D test -u root -p'

#}}}

#vim:foldmethod:marker
