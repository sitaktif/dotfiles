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

# export GIT_PS1_SHOWDIRTYSTATE=true # *: unstaged changes, +: staged changes
# export GIT_PS1_SHOWSTASHSTATE=true # $: something is stashed
# export GIT_PS1_SHOWUNTRACKEDFILES=true # %: untracked files exist
# export GIT_PS1_SHOWUPSTREAM="auto" # <: behind upstream, >: ahead upstream, <>: diverged
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
    if [[ $(( $SECONDS - ${__RC_LAST_HISTORY_SECONDS:-0} )) -gt 10 ]]; then
        history -a  # Apprend new history to .bash_history
        __RC_LAST_HISTORY_SECONDS=$SECONDS
    fi
}

C_RST='\[\e[0m\]'
C_RED='\[\e[0;31m\]'
C_BLUE='\[\e[01;34m\]'
C_USER='\[\e[38;5;${L_PS1_HOST_COLOR}m\]'
C_DATE='\[\e[38;5;166m\]'
C_GIT='\[\e[38;5;63m\]'
C_GREEN='\[\e[0;32m\]'
C_YELLOW='\[\e[01;93m\]'
C_VENV=$C_GREEN


# Nice, complete prompt
function __rc_prompt_command() {
    local EXIT="$?"  # This needs to be first

    local PS_EXIT=""
    if [[ $EXIT != 0 ]]; then
        PS_EXIT="${C_RED}[$EXIT]${C_RST} "
    fi

    # Avoid using pipes since subprocesses are expensive
    local -i job_count=0
    for i in $(jobs); do
      [[ $i == Running || $i == Sleeping ]] && job_count+=1
    done

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

    # Z (autojump like thing) - defined in other .bashrc_xxx - replacing with FASD
    # "$L_Z_PROMPT_CMD" --add "$(command pwd -P 2>/dev/null)" 2>/dev/null
}
# Smaller prompt, good for presentations
function __rc_prompt_command2() {
    local EXIT="$?"  # This needs to be first

    local PS_EXIT=""
    if [[ $EXIT != 0 ]]; then
        PS_EXIT="${C_RED}[$EXIT]${C_RST} "
    fi

    PS1=""
    PS1+="${C_DATE}$(date +%H:%M) ${PS_EXIT}${C_BLUE}\W \$${C_RST} "

    __rc_append_bash_history_maybe

    # Z (autojump like thing) - defined in other .bashrc_xxx - replacing with FASD
    # "$L_Z_PROMPT_CMD" --add "$(command pwd -P 2>/dev/null)" 2>/dev/null
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
export PATH=~/bin/local:~/bin:~/bin/scripts:${GOPATH:-$USER/go}/bin:$PATH

# General
export EDITOR=vim
export VISUAL=vim

# Bash
shopt -s histappend
export HISTCONTROL=ignoredups
export HISTFILESIZE=100000
export HISTSIZE=100000

# Less (--quit-if-one-screen needs version >= 520 to work with alternate screens, i.e. without --no-init)
# Tab is 4 spaces, search ignores case, enable colours, cat if less than one screen.
# --status-column: column to show lines matching current search or first unread line after moving,
# --ignore-case: smartcase search, --LONG-PROMPT: verbose prompt, --RAW-CONTROL-CHARS: show colors,
# --HILITE-UNREAD: highlight first unread line moving, --tabs=4: tab is 4 spaces,
# --window=-4: keep 4 lines overlapping when scrolling with the space key
export LESS='--tabs=4 --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS --status-column --LONG-PROMPT --HILITE-UNREAD --window=-4'

# Pager
export PAGER=less

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

# Wrapper that creates a completion function on the fly for aliases that contain arguments.
#
# For aliases that don't take arguments you can directly set the completion function with e.g. 
# complete -o default -F _git g   # Assuming 'g' is the alias and '_git' is
# the completion function.
#
# A convention for completion is to prefix with '_', for example completion for
# 'git' is '_git' and completion for 'git log' is '_git_log'.
#
# To find out what the completer function is called: complete -p <cmd>
# (although sometimes the above doesn't work because e.g. fzf wraps around it).
#
# Usage (here '_my_git_remote_rm' is an arbitrary identifier):
#
# make-completion-wrapper _git _my_git_remote_rm git remote rm  # Create the compl func
# complete -F _my_git_remote_rm grr                             # Assign to alias
#
make_completion_wrapper() {
    local comp_function_name="$1"
    local function_name="$2"
    local arg_count=$(($#-3))
    shift 2
    # shellcheck disable=SC2124
    local function="
        function $function_name {
            ((COMP_CWORD+=$arg_count))
            COMP_WORDS=( \"$@\" \${COMP_WORDS[@]:1} )
            \"$comp_function_name\"
            return 0
        }"
    eval "$function"
    # echo "$function_name"
    # echo "$function"
    
    # Not quite working yet...
    # make_completion_wrapper _git_remote _my_git_remote_rm git-remote rm
    # complete -o default -F _my_git_remote_rm grr
}

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
alias gg='git log --graph --color --pretty=format:"%x1b[31m%h%x09%C(auto)%d%Creset%x20%s"'
alias gg2='git log --graph --color --pretty=format:"%x1b[31m%h%x09%x20%x1b[0m%s%x1b[32m%d%x1b[0m"'
alias gga='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%C(auto)%d%Creset%x20%s"'
alias gga2='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x20%x1b[0m%s%x1b[32m%d%x1b[0m"'
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --date=local"
alias gap="git add -p"
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
alias grec='git rebase --cont'
alias grea='git rebase --abort'
alias gpullod='git pull origin dev'
alias gpullom='git pull origin master'
alias gpullud='git pull up dev'
alias gpullum='git pull up master'
alias gpushod='git push origin dev'
alias gpushom='git push origin master'
alias gpushud='git push up dev'
alias gpushum='git push up master'

# Completion for aliases
complete -o default -F _git g

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

alias ,='cd ..'
alias ,,='cd ../..'
alias ,,,='cd ../../..'
alias ,,,,='cd ../../../..'
alias ,,,,,='cd ../../../../..'
alias ,,,,,,='cd ../../../../../..'

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
ff() {
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
alias dr='docker run -ti'
alias drr='docker run -ti --rm'

# Handy prefixes
alias left='DISPLAY=:0.0'
alias right='DISPLAY=:0.1'

# Editor related
alias e="$L_VIM"

# Incentive to use 'e' to edit stuff
alias vim="echo 'Use e for neovim or rvim for regular vim'"

# Regular vim
alias rvim='command vim'  # The 'command' builtin ensures we don't resolve functions/aliases

# TODO(rchossart): need to prefix this with condition of existence of fzf
complete -F _fzf_file_completion -o default -o bashdefault e
alias did='vim +"normal Go" +"r!date" ~/notes/did.txt'

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
alias vimv="e ~/.vim/vimrc"

alias k=kubectl

alias c=cargo
alias cb='cargo build'

############################
#        BOOKMARKS         #
############################

# Other
alias restore_vim_session='vim $(find . -name ".*.swp" | while read f; do rm "$f"; echo "$f" | sed "s/\\.\\([^/]*\\).swp/\\1/"; done)'
alias vless='vim -u /usr/share/vim/vim72/macros/less.vim'
alias myports='netstat -alpe --ip'


############################
#        FUNCTIONS         #
############################


## Fuzzy-finder (fzf) - see https://junegunn.kr/2016/07/fzf-git/

# multi-selection, 60% height (default 40%),
export FZF_DEFAULT_OPTS='--multi --height=60% --bind ctrl-t:toggle-all,alt-j:jump,alt-k:jump-accept,alt-p:toggle-preview'

# No worky?
# --no-hscroll
# --bind ctrl-v:toggle-preview --preview-window down:3:hidden

# Open results of rg in vim, with fzf filtering
# TODO: add one that uses fzf to choose the files
alias re='$EDITOR -q <($(fc -ln -1) --vimgrep)'


### FZF - Awesome git previews

## FZF aliases / functions

# Fzf local git repos
gp() {
	local dir
	dir=$(find ~/git ~/src ~/geo ~/go/src/github.pie.*.com/pie -mindepth 1 -maxdepth 1 -type d |
		fzf "$@")
	[[ -n "$dir" ]] && cd "$dir"
}

## FZF completions
#
# See https://github.com/junegunn/fzf/wiki/Examples-(completion)

# Custom fuzzy completion for "z" command
#   e.g. z **<TAB>
_fzf_complete_z() {
	FZF_COMPLETION_TRIGGER='' FZF_COMPLETION_OPTS="$FZF_COMPLETION_OPTS --tac --no-sort" \
		_fzf_complete --reverse "$@" < <(_z -l 2>&1)
	COMPREPLY=$(sed -E 's/[^ ]*[[:space:]]+//' <<< "$COMPREPLY")

	# Need to add the following (doing it at the end of this file
	# to override z completion)
	# if [[ -n "$BASH" ]]; then
	# 	complete -F _fzf_complete_z -o default -o bashdefault z
	# fi
}


## FZF key bindings

# Fzf git files (unstaged).
_gib_git_f() {
	git -c color.status=always status --short |
		fzf --height 50% "$@" --border -m --ansi --nth 2..,.. \
		--preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' | cut -c4- | sed 's/.* -> //'
}
# Fzf git branches.
_gib_git_b() {
	git branch -a --color=always --sort=committerdate --sort=-refname:rstrip=2 | grep -v '/HEAD\s' |
		fzf --height 50% "$@" --border --ansi --multi --tac --preview-window right:70% \
		--preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' | sed 's/^..//' | cut -d' ' -f1 | sed 's#^remotes/##'
}
# Fzf git tags.
_gib_git_t() {
	git tag --sort -version:refname |
		fzf --height 50% "$@" --border --multi --preview-window right:70% \
		--preview 'git show --color=always {} | head -200'
}
# Fzf git commits.
_gib_git_h() {
	git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
		fzf --height 50% "$@" --border --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
		--header 'Press CTRL-S to toggle sort' \
		--preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' | grep -o "[a-f0-9]\{7,\}"
}
# Fzf git remotes.
_gib_git_r() {
	git remote -v | awk '{print $1 "\t" $2}' | uniq |
		fzf --height 50% "$@" --border --tac \
		--preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
		cut -d$'\t' -f1
}
# More fzf helpers.
#_gib_join-lines() { local item; while read item; do echo -n "${(q)item} "; done; }
# TODO: the eval is breaking syntax
bind-git-helper() {
    local c
    bind '"\er": redraw-current-line'
    for c in "$@"; do
        eval "bind '\"\\C-g\\C-$c\": \"\$(_gib_git_$c)\\e\\C-e\\er\" '"
    done
}

bind-git-helper f b t h r
unset -f bind-git-helper


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

# Load z (jump to directories, see `man z`) if brew is installed and z is too
if command -v brew >/dev/null 2>&1; then
	# Load rupa's z if installed
	[ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

# Add the fuzzyfinder completion
if [[ -n "$BASH" ]]; then
	complete -r z
	complete -F _fzf_complete_z -o default -o bashdefault z
fi

# FASD is like z with more features but my conclusion is it's way too slow
# (it "skips" prompts when I keep enter pressed)
#
# # Slower version
# # eval "$(fasd --init auto)"
#
# # Faster version... but actaully the bash-hook that prepends stuff to BASH_PROMPT is still SUPER slow (too many pipes/process calls)
# fasd_cache="$HOME/.fasd-init-bash"
# if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
#   fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
# fi
# source "$fasd_cache"
# unset fasd_cache
#
# FASD additional aliases
# alias v='f -t -e vim -b viminfo'  # This is not working :(((

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# vim: foldmethod=marker sw=4 ts=4 sts=4 et
