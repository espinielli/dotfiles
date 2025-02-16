#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh


# from https://hidutil-generator.netlify.app/
# remap CAPS-LOCK to (left) CTRL, see file
# ~/Library/LaunchAgents/com.local.KeyRemapping.plist

# for profiling zsh
# https://unix.stackexchange.com/a/329719/27109
#
zmodload zsh/zprof



export SCRIPTS=${HOME}/scripts
export ZSHCONFIG=${ZDOTDIR:-$HOME}/.zsh-config
ZSH_INIT=${ZSHCONFIG}/_init.sh

if [[ -s ${ZSH_INIT} ]]; then
    source ${ZSH_INIT}
else
    echo "Could not find the init script ${ZSH_INIT}"
fi

#
# https://gist.github.com/ctechols/ca1035271ad134841284
# https://carlosbecker.com/posts/speeding-up-zsh
#
autoload -Uz compinit

case $SYSTEM in
  Darwin)
    if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
      compinit;
    else
      compinit -C;
    fi
    ;;
  Linux)
    # not yet match GNU & BSD stat
  ;;
esac

for file in ~/.{aliases,functions,path,extra,exports}; do
    # shellcheck disable=SC1090
    [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

# for PURE prompt /opt/homebrew/share/zsh/site-functions
fpath+=("/opt/homebrew/share/zsh/site-functions")

# see zplugin-init.zsh with Turbo Mode
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://direnv.net/
# see zplugin-init.zsh
# https://github.com/zdharma/zplugin/wiki/Direnv-explanation
#eval "$(direnv hook zsh)"

# prompt using zsh pure, see github
autoload -U promptinit; promptinit
prompt pure


# Private script here
if [ -d ~/.private ]; then
    for f in ~/.private/*sh; do
        source "$f"
    done
fi


export RLWRAP_EDITOR=vim

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/opt/homebrew/opt/micromamba/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/spi/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# espinielli addition: really needed?
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

# rust
. "$HOME/.cargo/env"            # For sh/bash/zsh/ash/dash/pdksh

# Go
PATH=$PATH:$HOME/go/bin

# quarto version manager
export PATH="$(qvm path add)"


# Created by `pipx` on 2024-06-12 13:28:56
export PATH="$PATH:/Users/spi/.local/bin"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/mc mc

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
