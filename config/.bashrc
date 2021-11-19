## Defines both bash and zsh options
if [[ -f ~/.commonrc ]]; then
    . ~/.commonrc
fi
. "$HOME/.cargo/env"
