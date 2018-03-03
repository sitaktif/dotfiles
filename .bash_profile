[[ -s ~/.bashrc ]] && source ~/.bashrc ;

# iTerm2 shell integration is nice but it messes up with the 'exit code' on the prompt
# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH
