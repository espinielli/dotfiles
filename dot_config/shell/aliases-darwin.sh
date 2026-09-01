# shellcheck shell=bash
# Interactive aliases specific to macOS.

alias o='open'
alias oo='open .'
alias cz='chezmoi'
alias cze='EDITOR="positron --wait" chezmoi edit'

alias cleanup='find . -type f -name .DS_Store -print -delete'
alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'
alias spotoff='sudo mdutil -a -i off'
alias spoton='sudo mdutil -a -i on'

if [[ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
    alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
fi

if ! command -v md5sum >/dev/null 2>&1 && command -v md5 >/dev/null 2>&1; then
    alias md5sum='md5'
fi
