# shellcheck shell=bash
# Interactive aliases shared across macOS, Linux, and Git Bash.

# Navigation and shell
alias ..='cd ..'
alias h='history'
alias cls='clear'
alias m='more'
alias incognito='unset HISTFILE'

# Git
alias gst='git status'
alias gss='git status --short'
alias gr='git remote'
alias nogit='git ls-files --exclude-standard -o'
alias rm-untracked='git stash push --include-untracked && git stash drop'

# Tools
alias mm='micromamba'
alias r='radian'

# Interactive safeguards. Prefix with command to bypass deliberately.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# HTTP method shortcuts require libwww-perl's lwp-request.
if command -v lwp-request >/dev/null 2>&1; then
    alias GET='lwp-request -m GET'
    alias HEAD='lwp-request -m HEAD'
    alias POST='lwp-request -m POST'
    alias PUT='lwp-request -m PUT'
    alias DELETE='lwp-request -m DELETE'
    alias TRACE='lwp-request -m TRACE'
    alias OPTIONS='lwp-request -m OPTIONS'
fi
