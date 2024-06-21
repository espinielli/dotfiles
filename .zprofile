# vim:syntax=sh
# vim:filetype=sh

#
# Executes commands at login before zshrc.
#
if [[ -z "$LANG" ]]; then
    export LANG='en_US.UTF-8'
    export LANGUAGE=en_US.UTF-8
fi

export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESSCHARSET=utf-8

# eliminates duplicates in *paths
typeset -gU cdpath fpath path

# Zsh search path for executable
path=(
  /usr/local/{bin,sbin}
  $path
)

# -- homebrew --
if [[ $(uname -s) = "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"

# Quarto setup
export PATH="$(qvm path add)"
