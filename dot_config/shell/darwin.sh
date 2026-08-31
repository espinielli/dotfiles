# shellcheck shell=sh

export BASH_SILENCE_DEPRECATION_WARNING=1
export BROWSER="${BROWSER:-open}"

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -d /Applications/Obsidian.app/Contents/MacOS ]; then
    path_append /Applications/Obsidian.app/Contents/MacOS
    export PATH
fi
