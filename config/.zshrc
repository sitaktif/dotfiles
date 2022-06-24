## Defines both bash and zsh options
if [[ -f ~/.zshrc.misc ]]; then
    . ~/.zshrc.misc
fi
if [[ -f ~/.commonrc ]]; then
    . ~/.commonrc
fi

# This is slow. Given how often I use conda, I can just activate it manually when needed.
#
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/rchossart/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/rchossart/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/rchossart/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/rchossart/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
