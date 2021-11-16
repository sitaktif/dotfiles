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
[[ $- == *i* ]] && source "$brew_prefix/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$brew_prefix/opt/fzf/shell/key-bindings.bash"
