alias chx="find . -name '*.sh' -exec chmod +x {} \;"
alias chxz="find . -name '*.zsh' -exec chmod +x {} \;"
alias reload="source ~/.zshrc"

eval $(thefuck --alias)

export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"