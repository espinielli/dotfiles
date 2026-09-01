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

eval "$(~/.local/bin/mise activate bash)"
export PATH="$PATH:$(qvm path add)"
if command -v qvm >/dev/null 2>&1; then
    export PATH="$PATH:$(qvm path add)"
fi
