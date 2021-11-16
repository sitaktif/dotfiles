# Setup fzf
# ---------
if command -v brew >/dev/null 2>&1; then
  brew_prefix=$(brew --prefix)
elif [[ -d /opt/brew ]]; then
  brew_prefix=/opt/brew
else
  brew_prefix=/usr/local
fi

if [[ ! "$PATH" == *$brew_prefix/opt/fzf/bin* ]]; then
  export PATH="$PATH:$brew_prefix/opt/fzf/bin"
fi

# Auto-completion
# ---------------
if [[ -e $brew_prefix/opt/fzf/shell/completion.zsh ]]; then
  [[ $- == *i* ]] && source "$brew_prefix/opt/fzf/shell/completion.zsh" 2> /dev/null
fi

# Key bindings
# ------------
if [[ -e $brew_prefix/opt/fzf/shell/key-bindings.zsh ]]; then
  source "$brew_prefix/opt/fzf/shell/key-bindings.zsh"
fi
