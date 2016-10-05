#!/bin/bash
# A basically sane bash environment.
#
# Original from Ryan Tomayko <http://tomayko.com/about> (with help from the internets).
# and https://github.com/mathiasbynens/dotfiles
# and https://github.com/jessfraz/dotfiles
# Additions from Enrico Spinielli

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	  *i*) ;;
	  *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac



# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [[ -f /usr/share/bash-completion/bash_completion ]]; then
		. /usr/share/bash-completion/bash_completion
	elif [[ -f /etc/bash_completion ]]; then
		. /etc/bash_completion
	fi
fi
for file in /etc/bash_completion.d/* ; do
	source "$file"
done

if [[ -f $HOME/.bash_profile ]]; then
	source $HOME/.bash_profile
fi

# use a tty for gpg
# solves error: "gpg: signing failed: Inappropriate ioctl for device"
export GPG_TTY=$(tty)
# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
	gpg-connect-agent /bye >/dev/null 2>&1
	gpg-connect-agent updatestartuptty /bye >/dev/null
fi
# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi






# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# readline config
: ${INPUTRC=~/.inputrc}

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
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
#     . $(brew --prefix)/etc/bash_completion
# fi
# if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
#     . $(brew --prefix)/share/bash-completion/bash_completion
# fi

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
            $(brew --prefix)/etc/bash_completion \
            /usr/local/etc/bash_completion.d/hub.bash_completion.sh \
            ~/.git-flow-completion.bash; do
    [ -r "$file" ] && source "$file"
done
unset file
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true

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





# source ~/.shenv now if it exists
test -r ~/.shenv && . ~/.shenv

# condense PATH entries
export PATH=$(puniq $PATH)
export MANPATH=$(puniq $MANPATH)

source ~/.xsh

# added by travis gem
[ -f /Users/espin/.travis/travis.sh ] && source /Users/espin/.travis/travis.sh
