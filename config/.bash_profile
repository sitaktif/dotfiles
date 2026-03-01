[[ -s ~/.bashrc ]] && source ~/.bashrc ;

export TERM=${TERM:-xterm-256color}
export PATH="$HOME/.poetry/bin:$PATH"

[[ -f ~/.profile ]] && . ~/.profile
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -f "/snap/bin" ]] && export PATH="$PATH:/snap/bin"
