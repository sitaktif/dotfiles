###############################
#      SYSTEM SPECIFIC        #
###############################

# Non-interactive mode
[[ -z "$PS1" ]] && return

# Default values defined in system-specific rc-files - "L_" for "LOCAL"
[[ -z "$(which vim)" ]] && export L_VIM="vi" || export L_VIM="vim"

export L_PS1_HOST_COLOR="46" # Green by default
export L_PS1_ALREADY_SET=""

# Some tokens and other private stuff
# - HOMEBREW_GITHUB_API_TOKEN: github token to be used by homebrew (untick all permissions - public only)
[[ -e ~/.bashrc_private ]] && source ~/.bashrc_private

# Load OS-specific rc files
#
if [[ "$(uname)" == 'Darwin' ]]; then # Leopard
    source ~/.bashrc_mac
elif [[ "$(uname)" == 'Linux' ]]; then # Linux (slacker / kollok)
    source ~/.bashrc_linux
fi

# This one is only for local stuff
if [[ -e ~/.bashrc_misc ]]; then
    source ~/.bashrc_misc
fi

###############################
#           PROMPT            #
###############################

export GIT_PS1_SHOWDIRTYSTATE=true # *: unstaged changes, +: staged changes
export GIT_PS1_SHOWSTASHSTATE=true # $: something is stashed
# export GIT_PS1_SHOWUNTRACKEDFILES=true # %: untracked files exist
export GIT_PS1_SHOWUPSTREAM="auto" # <: behind upstream, >: ahead upstream, <>: diverged
L_Z_PROMPT_CMD=${L_Z_PROMPT_CMD:-true}

# then you can add \`jobs_count\` to the end of your PS1 like this
export PS1="\[\e[32m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\`git_branch\`\`jobs_count\`\n\$ "


## This is to have the last command's duration

function __rc_set_last_command_start_time {
  __RC_LAST_COMMAND_START=${__RC_LAST_COMMAND_START:-$SECONDS}
}
trap '__rc_set_last_command_start_time' DEBUG

  # Append to history if it's been a while
__rc_append_bash_history_maybe() {
    # $SECONDS represents the # seconds since the start of the session
    if [[ $(( $SECONDS - ${__RC_LAST_SECONDS:-0} )) -gt 10 ]]; then
      history -a  # Apprend new history to .bash_history
    fi
    __RC_LAST_SECONDS=SECONDS
}

# Nice, complete prompt
function __rc_prompt_command() {
    local EXIT="$?"  # This needs to be first

    local C_RST='\[\e[0m\]'
    local C_RED='\[\e[0;31m\]'
    local C_GREEN='\[\e[0;32m\]'
    local C_BLUE='\[\e[01;34m\]'
    local C_YELLOW='\[\e[01;93m\]'
    local C_USER='\[\e[38;5;${L_PS1_HOST_COLOR}m\]'
    local C_VENV=$C_GREEN
    local C_DATE='\[\e[38;5;166m\]'
    local C_GIT='\[\e[38;5;63m\]'

    local PS_EXIT=""
    if [[ $EXIT != 0 ]]; then
        PS_EXIT="${C_RED}[$EXIT]${C_RST} "
    fi

    local job_count=$(jobs -l | grep 'Running\|Suspended' | wc -l)
    local job_count_prompt
    if [[ $job_count -gt 0 ]]; then
        job_count_prompt="${C_YELLOW}[${job_count}]${C_RST} "
    fi

    # $__RC_LAST_COMMAND_START is set by the DEBUG trap above
    local last_cmd_time_seconds=$(($SECONDS - $__RC_LAST_COMMAND_START))
    if [[ $last_cmd_time_seconds -gt 2 ]]; then
        PS_JOB_TIME="${C_YELLOW}[${last_cmd_time_seconds}s]${C_RST} "
    else
        PS_JOB_TIME=""
    fi
    unset __RC_LAST_COMMAND_START

    PS1=""
    PS1+="$job_count_prompt"
    [[ -n $VIRTUAL_ENV ]] && PS1+="${C_VENV}(venv)${C_RST} "
    PS1+="${C_GIT}$(__git_ps1 "(%s) ")${C_USER}\u:${C_RST}"
    PS1+="${C_DATE}$(date +%H:%M:%S)${C_BLUE}${_P_SSH} ${PS_EXIT}${PS_JOB_TIME}${C_BLUE}\w \$${C_RST} "

    __rc_append_bash_history_maybe

    # Z (autojump like thing) - defined in other .bashrc_xxx
    "$L_Z_PROMPT_CMD" --add "$(command pwd -P 2>/dev/null)" 2>/dev/null
}
# Smaller prompt, good for presentations
function __rc_prompt_command2() {
    local EXIT="$?"  # This needs to be first

    local C_RST='\[\e[0m\]'
    local C_RED='\[\e[0;31m\]'
    local C_BLUE='\[\e[01;34m\]'
    local C_USER='\[\e[38;5;${L_PS1_HOST_COLOR}m\]'
    local C_DATE='\[\e[38;5;166m\]'
    local C_GIT='\[\e[38;5;63m\]'

    local PS_EXIT=""
    if [[ $EXIT != 0 ]]; then
        PS_EXIT="${C_RED}[$EXIT]${C_RST} "
    fi

    PS1=""
    PS1+="${C_DATE}$(date +%H:%M) ${PS_EXIT}${C_BLUE}\W \$${C_RST} "

    __rc_append_bash_history_maybe

    # Z (autojump like thing) - defined in other .bashrc_xxx
    "$L_Z_PROMPT_CMD" --add "$(command pwd -P 2>/dev/null)" 2>/dev/null
}

# stalker: purple - slacker: bordeaux - kollok: orange - blinker: 'skin'
if [[ -z $L_PS1_ALREADY_SET ]]; then
    if [[ -n $SSH_CLIENT ]]; then export _P_SSH=" (ssh)" ; fi
    export PROMPT_COMMAND=__rc_prompt_command  # Func to gen PS1 after CMDs
fi

alias prompt_default='export PROMPT_COMMAND=__rc_prompt_command'
alias prompt_simple='export PROMPT_COMMAND=__rc_prompt_command2'

###############################
#          OPTIONS            #
###############################

# Binaries in home
export PATH=~/bin/local:~/bin:~/bin/scripts:$PATH

# General
export EDITOR=vim
export VISUAL=vim

# Bash
shopt -s histappend
export HISTCONTROL=ignoredups
export HISTFILESIZE=100000
export HISTSIZE=100000

# Go
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin

# Rsync and others transfer apps
export UPLOAD_BW_LIMIT=400

# App-specific
export MPD_HOST=localhost
export TEXMFHOME=~/.texmf

if [ -f "$HOME/.dircolors" ] ; then
    # Works for Mac - does it for others?
    eval "$(dircolors "$HOME/.dircolors")"
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

alias p=python
alias pse='python setup.py'
alias pset='python setup.py test'
alias psep='python setup.py package'

# gradle
gw() { # Run gradle if found in the current or parent directories
    for i in . .. ../.. ../../.. ../../../..; do
        if [[ -x $i/gradlew ]]; then
            (cd $i && ./gradlew "$@") ; return
        fi
    done
    echo "No gradlew found in current or parent directories"
}

# git
alias gg='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%C(auto)%d%Creset%x20%s"'
alias gg2='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x20%x1b[0m%s%x1b[32m%d%x1b[0m"'
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --date=local"
# Edit files in conflict
alias gec="git diff --name-only | uniq | xargs $EDITOR"

gl2() {
    # Escape < and > for github markdown
    git log --pretty=format:'* %Cred%h%Creset - %s %n%w(76,4,4)%b%n' --abbrev-commit "$@" | perl -0 -p -e 's/(^|[^\\])([<>])/\1\\\2/g ; s/(\s*\n)+\*/\n\n*/g'
  }
gl3() {
    # Escape < and > for github markdown, no color
    git log --pretty=format:'* %h - %s %n%w(76,4,4)%b%n' --abbrev-commit "$@" | perl -0 -p -e 's/(^|[^\\])([<>])/\1\\\2/g ; s/(\s*\n)+\*/\n\n*/g'
}

gpr() {
    # Create a pull request from the current feature branch

    local github_user=rchossart  # <-- Amend accordingly

    command -v hub >/dev/null 2>&1|| { echo "This requires 'hub' to be installed --> 'brew install hub'"; return 1; }
    local symbolic_rev=$(git rev-parse --abbrev-ref HEAD)
    if [[ $symbolic_rev == HEAD ]]; then
        echo "Cannot create PR in detached HEAD mode." && return 1
    elif [[ $symbolic_rev =~ ^dev$|^devel$|^master$|^release$ ]]; then
        echo "Not creating PR from '$symbolic_rev'. Please use a feature branch instead." && return 2
    fi
    git push origin "$symbolic_rev" -u
    hub compare "$github_user:$symbolic_rev"
}

alias g=git
alias gra='git remote add'
alias grr='git remote rm'
alias grv='git remote -v'
alias grei='git rebase -i'
alias grec='git rebase --cont'
alias grea='git rebase --abort'
alias gpullod='git pull origin dev'
alias gpullom='git pull origin master'
alias gpullud='git pull upstream dev'
alias gpullum='git pull upstream master'
alias gpushod='git push origin dev'
alias gpushom='git push origin master'
alias gpushud='git push upstream dev'
alias gpushum='git push upstream master'

# Core
alias ls='ls --color=auto'
alias sl='ls'
alias l='ls'
alias ll='ls -ahl'

lsd() { ls -F "$@" |grep '/$'  ; }
lsl() { ls -F "$@" |grep '@$'  ; }
lsx() { ls -F "$@" |grep '\*$' ; }

# Directory change functions
mkcd () {
    mkdir -p "$*" ; cd "$*"
}

function , ()      { cd .. ; }
function ,, ()     { cd ../.. ; }
function ,,, ()    { cd ../../.. ; }
function ,,,, ()   { cd ../../../.. ; }
function ,,,,, ()  { cd ../../../../.. ; }
function ,,,,,, () { cd ../../../../../.. ; }

# cd to the first parent dir containing .git/
function cdg() {
    local curdir=$(pwd)
    while curdir=$(dirname "$curdir"); do
        [[ -e $curdir/.git ]] && cd "$curdir" && return
    done
}

# Utilities (grep, basename, dirname)
alias grep='grep --color'
alias gri='grep -rI'
grio() { grep -rIO "$@" 2>/dev/null ; }

alias ag='ag --ignore .venv --ignore tags --ignore TAGS'

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
alias dus='du -shm * .[^.]* | sort -n'
alias psa='ps aux'
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

# Docker
alias d='docker'
alias dr='docker run -ti'
alias di='docker images'
dsh() {
    docker run -ti --rm "$@" bash
}


# Handy prefixes
alias left='DISPLAY=:0.0'
alias right='DISPLAY=:0.1'

# Editor related
alias e="$L_VIM"

# Bash, zsh, vim RC files
alias sob='source ~/.bashrc'
alias vimb="e ~/.bashrc"
alias vimbm="e ~/.bashrc_mac"
alias vimbs="e ~/.bashrc_slacker"
alias vimbl="e ~/.bashrc_linux"
alias vimbg="e ~/.bashrc_slacker"
alias vimbk="e ~/.bashrc_kollok"
alias vimg="e ~/.gitconfig"
alias soz="source ~/.zshrc"
alias vimz="e ~/.zshrc"
alias vimv="e ~/.vimrc"

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
alias restore_vim_session='vim $(find . -name ".*.swp" | while read f; do rm "$f"; echo "$f" | sed "s/\\.\\([^/]*\\).swp/\\1/"; done)'
alias vless='vim -u /usr/share/vim/vim72/macros/less.vim'
alias myports='netstat -alpe --ip'


## Python {{{
# Virtualenv activate
alias vv='virtualenv .venv && . .venv/bin/activate'
va() {
    if [[ -d .venv${1:-} ]]; then
        . .venv${1:-}/bin/activate
        echo "Activated virtualenv from .venv${1:-}/"
    elif [[ -d venv${1:-} ]]; then
        . venv${1:-}/bin/activate
        echo "Activated virtualenv from venv${1:-}/"
    else
        echo "No .venv${1:-} or venv${1:-} directory found in cwd."
        return 1
    fi
}
alias vd=deactivate

alias tip='touch __init__.py'

# pytest, no coverage, no warning
alias pt="CI=1 unbuffer pytest --no-cov --junit-xml='' --disable-pytest-warnings | sed 's/WARNING: Coverage disabled via --no-cov switch!//'"

#}}}

if [ -n "$TERM" ] && [ -x "$(which keychain)" ] && \
    [ -f "$HOME/.ssh/id_rsa" ] ; then
    keychain -q $HOME/.ssh/id_rsa
    . $HOME/.keychain/$(hostname)-sh
fi


[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

#vim:foldmethod:marker
