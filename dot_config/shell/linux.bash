# shellcheck shell=bash

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -r /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

if command -v xdg-open >/dev/null 2>&1; then
    alias o='xdg-open'
    alias oo='xdg-open .'
fi
