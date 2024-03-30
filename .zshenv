#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

export SYSTEM=$(uname -s)

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Home-made scripts
export PATH=$PATH:${HOME}/.bin

# espinielli addition: really needed?
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=~/.local/homebrew/share/zsh-syntax-highlighting/highlighters
. "$HOME/.cargo/env"
