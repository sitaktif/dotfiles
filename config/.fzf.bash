if command -v fzf >/dev/null 2>&1; then
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
    if [[ $- == *i* ]]; then
        if [[ -e /usr/share/bash-completion/completions/fzf ]]; then
            source /usr/share/bash-completion/completions/fzf
        elif [[ -e "$brew_prefix/opt/fzf/shell/completion.bash" ]]; then
            source "$brew_prefix/opt/fzf/shell/completion.bash" 2> /dev/null
        fi
    fi

    # Key bindings
    # ------------
    if [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
      source /usr/share/doc/fzf/examples/key-bindings.bash
    else
      source "$brew_prefix/opt/fzf/shell/key-bindings.bash"
    fi
fi
