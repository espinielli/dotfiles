#!/bin/bash
# A basically sane bash environment.
#
# Original from Ryan Tomayko <http://tomayko.com/about> (with help from the internets).
# and https://github.com/mathiasbynens/dotfiles
# Additions from Enrico Spinielli

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# readline config
: ${INPUTRC=~/.inputrc}

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit
#   for example auth key for homebrew github token
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file


# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------
# bring in system bashrc
test -r /etc/bashrc && . /etc/bashrc

# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
#####################################
# Autocorrect typos in path names when using `cd`
shopt -s cdspell >/dev/null 2>&1

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1

# Append to the Bash history file, rather than overwriting it
shopt -s histappend >/dev/null 2>&1


# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

shopt -s interactive_comments >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" \
    -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" \
    scp sftp ssh
shopt -s hostcomplete >/dev/null 2>&1


# fuck that you have new mail shit
unset MAILCHECK
shopt -u mailwarn >/dev/null 2>&1

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# proxy auth in case of need (also used for other private pwd / auth keys, i.e. homebrew github token)
test -f ~/.http_proxy &&  . ~/.http_proxy

# special (machine/user specific) setup
# this is the true one, remove ~/private...
test -f ~/.config/.shenv.${HOSTNAME} && . ~/.config/.shenv.${HOSTNAME}


# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
source ~/.git-flow-completion.bash

# override and disable tilde expansion
_expand() {
    return 0
}

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# Autocomplete Grunt commands
#which grunt > /dev/null && eval "$(grunt --completion=bash)"

# completion for git & Co.
for file in /usr/local/etc/bash_completion.d/git-completion.bash \
            /usr/local/etc/bash_completion.d/git-extras \
            /usr/local/etc/bash_completion.d/hub.bash_completion.sh; do
    [ -r "$file" ] && source "$file"
done
unset file

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------
# extra paths are in .path (not in git)


# Load RVM into a shell session *as a function*
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


# ----------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac

# enable en_US locale w/ utf-8 encodings if not already configured
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# always use PASSIVE mode ftp
: ${FTP_PASSIVE:=1}
export FTP_PASSIVE

# ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"

# history stuff
HISTCONTROL=ignoreboth
HISTFILESIZE=10000
HISTSIZE=10000
# Avoid duplicates in your history
HISTIGNORE="&:ls:[bf]g:exit"


# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

# See what we have to work with ...
HAVE_SUBLIME=$(command -v subl)
HAVE_VIM=$(command -v vim)

# EDITOR
test -n "$HAVE_SUBLIME" &&
EDITOR="subl -w" ||
EDITOR=vim
export EDITOR

# PAGER
if test -n "$(command -v less)" ; then
    PAGER="less -FirSwX"
    MANPAGER="less -FiRswX"
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# Ack
ACK_PAGER="$PAGER"
ACK_PAGER_COLOR="$PAGER"

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------
[ -r /usr/local/etc/bash_completion.d/git-prompt.sh ] && \
    source /usr/local/etc/bash_completion.d/git-prompt.sh  # from brew installed git

GIT_BRANCH='$(__git_ps1 " (%s)")'

RED="\[\033[0;31m\]"
BROWN="\[\033[0;33m\]"
GREY="\[\033[0;97m\]"
BLUE="\[\033[0;34m\]"
PS_CLEAR="\[\033[0m\]"
SCREEN_ESC="\[\033k\033\134\]"

if [ "$LOGNAME" = "root" ]; then
    COLOR1="${RED}"
    COLOR2="${BROWN}"
    P="#"
elif hostname | grep -q 'github\.com'; then
    GITHUB=yep
    COLOR1="\[\e[0;94m\]"
    COLOR2="\[\e[0;92m\]"
    P="\$"
else
    COLOR1="${BLUE}"
    COLOR2="${BROWN}"
    P="\$"
fi

prompt_simple() {
    unset PROMPT_COMMAND
    PS1="[\u@\h:\w$GIT_BRANCH]\$ "
    PS2="> "
}

prompt_compact() {
    unset PROMPT_COMMAND
    PS1="${COLOR1}${P}${PS_CLEAR} "
    PS2="> "
}

prompt_color() {
    PS1="${BLUE}[${COLOR1}\u${BLUE}@${COLOR2}\h${BLUE}:${COLOR1}\W${BROWN}$GIT_BRANCH${BLUE}]${COLOR2}$P${PS_CLEAR} "
    PS2="\[[33;1m\]continue \[[0m[1m\]> "
}

# ----------------------------------------------------------------------
# MACOS X / DARWIN SPECIFIC
# ----------------------------------------------------------------------
if [ $(uname) = Darwin ]; then
    # put ports on the paths if /opt/local exists
    test -x /opt/local -a ! -L /opt/local && {
        PORTS=/opt/local

        # setup the PATH and MANPATH
        PATH="$PORTS/bin:$PORTS/sbin:$PATH"
        MANPATH="$PORTS/share/man:$MANPATH"

        # nice little port alias
        alias port="sudo nice -n +18 $PORTS/bin/port"
    }

    test -x /usr/pkg -a ! -L /usr/pkg && {
        PATH="/usr/pkg/sbin:/usr/pkg/bin:$PATH"
        MANPATH="/usr/pkg/share/man:$MANPATH"
    }

    # put brew on the paths if /usr/local exists
    test -x /usr/local -a ! -L /usr/local && {
        BREW=/usr/local

        # setup the PATH and MANPATH
        PATH="$BREW/bin:$BREW/sbin:$PATH"
        MANPATH="$BREW/share/man:$MANPATH"

        # nice little port alias
        alias brew="nice -n +18 $BREW/bin/brew"

        # gnu coreutils from brew
        PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

        # python
#        export PYTHONPATH="$(brew --prefix)/lib/python2.7/site-packages:$PYTHONPATH"
#        alias ipython='python /usr/local/bin/ipython'

        # pyenv & Co.
        if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
        if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
        # export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

        # pip should only run if there is a virtualenv currently activated
        # export PIP_REQUIRE_VIRTUALENV=true
        # cache pip-installed packages to avoid re-downloading
        # export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

        # syspip(){
        #     # turn off virtualenv-only for global installations
        #     # see http://hackercodex.com/guide/python-development-environment-on-mac-osx/
        #     PIP_REQUIRE_VIRTUALENV="" pip "$@"
        # }

        # virtualenv wrapper
        # export WORKON_HOME=$HOME/.virtualenvs
        # export PROJECT_HOME=$HOME/Devel
        # source /usr/local/bin/virtualenvwrapper.sh
    }



    # setup java environment. puke.
    JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
    ANT_HOME="/Developer/Java/Ant"
    export ANT_HOME JAVA_HOME

    # hold jruby's hand
    test -d /opt/jruby &&
    JRUBY_HOME="/opt/jruby"
    export JRUBY_HOME
fi


# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

# we always pass these to ls(1)
LS_COMMON="-hBG"

# if the dircolors utility is available, set that up to
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
}
unset dircolors

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls="command ls $LS_COMMON"

# these use the ls aliases above
alias ll="ls -l"
alias l.="ls -d .*"
alias la="ls -la"

# --------------------------------------------------------------------
# MISC ALIASES
# --------------------------------------------------------------------
alias node="env NODE_NO_READLINE=1 rlwrap node"

# --------------------------------------------------------------------
# MISC COMMANDS
# --------------------------------------------------------------------

# push SSH public key to another box
push_ssh_cert() {
    local _host
    test -f ~/.ssh/id_dsa.pub || ssh-keygen -t dsa
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_dsa.pub
    done
}

# --------------------------------------------------------------------
# PATH MANIPULATION FUNCTIONS
# --------------------------------------------------------------------

# Usage: pls [<var>]
# List path entries of PATH or environment variable <var>.
pls () { eval echo \$${1:-PATH} |tr : '\n'; }

# Usage: pshift [-n <num>] [<var>]
# Shift <num> entries off the front of PATH or environment var <var>.
# with the <var> option. Useful: pshift $(pwd)
pshift () {
    local n=1
    [ "$1" = "-n" ] && { n=$(( $2 + 1 )); shift 2; }
    eval "${1:-PATH}='$(pls |tail -n +$n |tr '\n' :)'"
}

# Usage: ppop [-n <num>] [<var>]
# Pop <num> entries off the end of PATH or environment variable <var>.
ppop () {
    local n=1 i=0
    [ "$1" = "-n" ] && { n=$2; shift 2; }
    while [ $i -lt $n ]
    do eval "${1:-PATH}='\${${1:-PATH}%:*}'"
       i=$(( i + 1 ))
    done
}

# Usage: prm <path> [<var>]
# Remove <path> from PATH or environment variable <var>.
prm () { eval "${2:-PATH}='$(pls $2 |grep -v "^$1\$" |tr '\n' :)'"; }

# Usage: punshift <path> [<var>]
# Shift <path> onto the beginning of PATH or environment variable <var>.
punshift () { eval "${2:-PATH}='$1:$(eval echo \$${2:-PATH})'"; }

# Usage: ppush <path> [<var>]
ppush () { eval "${2:-PATH}='$(eval echo \$${2:-PATH})':$1"; }

# Usage: puniq [<path>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () {
    # use $@ instead of $1 to cater for pathnames containing spaces
    # also separate the various paths with '|' and reflect it in nl, sort and cut
    echo "$@" | sed -e 's/^[ ][ ]*//' -e 's/:$//' -e 's/^://' |tr : '\n' | nl -s '|' | sort -u -t '|' -k 2,2 |sort -n | \
    cut -f 2- -d '|' | tr '\n' : | sed -e 's/^[ ][ ]*//' -e 's/:$//' -e 's/^://'
}

# use gem-man(1) if available:
man () {
    gem man -s "$@" 2>/dev/null ||
    command man "$@"
}

# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

# bring in rbdev functions
. rbdev 2>/dev/null || true

# source ~/.shenv now if it exists
test -r ~/.shenv && . ~/.shenv

# condense PATH entries
export PATH=$(puniq $PATH)
export MANPATH=$(puniq $MANPATH)

# Use the color prompt by default when interactive
test -n "$PS1" && prompt_color
