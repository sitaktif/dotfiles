## Defines both bash and zsh options
if [[ -f ~/.commonrc ]]; then
    . ~/.commonrc
fi
[[ -e "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
