# shellcheck shell=bash

HISTSIZE=32768
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignoredups:erasedups
HISTIGNORE='ls:cd:cd -:pwd:exit:date:* --help'
export HISTSIZE HISTFILESIZE HISTCONTROL HISTIGNORE

shopt -s histappend nocaseglob cdspell
for bash_option in autocd globstar; do
    shopt -s "$bash_option" 2>/dev/null || true
done
unset bash_option

if [[ -r "$HOME/.bash_prompt" ]]; then
    source "$HOME/.bash_prompt"
fi

if declare -F _git >/dev/null 2>&1; then
    complete -o default -o nospace -F _git g 2>/dev/null || true
fi
