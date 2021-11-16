## Defines both bash and zsh options
if [[ -f ~/.zshrc.misc ]]; then
    . ~/.zshrc.misc
fi
if [[ -f ~/.commonrc ]]; then
    . ~/.commonrc
fi
