# shellcheck shell=bash

# Git for Windows normally initializes Git completion globally.
if [[ -r /etc/bash_completion ]]; then
    source /etc/bash_completion
fi
