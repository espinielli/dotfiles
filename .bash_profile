
# silence message about zsh being the default in new MacOS
export BASH_SILENCE_DEPRECATION_WARNING=1

complete -C /opt/homebrew/bin/mc mc

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
