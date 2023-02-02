[[ -s ~/.bashrc ]] && source ~/.bashrc ;

export TERM=${TERM:-xterm-256color}
export PATH="$HOME/.poetry/bin:$PATH"

[[ -f ~/.profile ]] && . ~/.profile
. "$HOME/.cargo/env"
