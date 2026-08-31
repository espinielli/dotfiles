# shellcheck shell=bash

if command -v brew >/dev/null 2>&1; then
    brew_prefix=$(brew --prefix 2>/dev/null)
    if [[ -n "$brew_prefix" ]]; then
        if [[ -r "$brew_prefix/etc/profile.d/bash_completion.sh" ]]; then
            export BASH_COMPLETION_COMPAT_DIR="$brew_prefix/etc/bash_completion.d"
            source "$brew_prefix/etc/profile.d/bash_completion.sh"
        elif [[ -r "$brew_prefix/etc/bash_completion" ]]; then
            source "$brew_prefix/etc/bash_completion"
        fi
    fi
    unset brew_prefix
fi

if command -v mc >/dev/null 2>&1; then
    complete -C "$(command -v mc)" mc 2>/dev/null || true
fi

alias o='open'
alias oo='open .'
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

unquarantine() {
    local attribute
    for attribute in \
        com.apple.metadata:kMDItemDownloadedDate \
        com.apple.metadata:kMDItemWhereFroms \
        com.apple.quarantine
    do
        xattr -r -d "$attribute" "$@"
    done
}
