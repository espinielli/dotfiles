# shellcheck shell=bash
# Interactive aliases shared by Bash and, where syntax permits, Zsh.

alias ..='cd ..'
alias h='history'
alias cls='clear'
alias m='more'

alias gst='git status'
alias gss='git status --short'
alias gr='git remote'
alias nogit='git ls-files --exclude-standard -o'

alias mm='micromamba'
alias r='radian'

# Interactive safeguards. Use command rm/cp/mv to bypass deliberately.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias incognito='unset HISTFILE'
