# shellcheck shell=bash
# Interactive aliases specific to Linux, including Raspberry Pi OS.

if command -v xdg-open >/dev/null 2>&1; then
    alias o='xdg-open'
    alias oo='xdg-open .'
fi
