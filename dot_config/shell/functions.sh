# shellcheck shell=bash
# Interactive functions shared across supported systems.

tre() {
    if ! command -v tree >/dev/null 2>&1; then
        printf '%s\n' 'tre: tree is not installed' >&2
        return 127
    fi
    tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

man() {
    env \
        LESS_TERMCAP_mb="$(printf '\033[1;31m')" \
        LESS_TERMCAP_md="$(printf '\033[1;31m')" \
        LESS_TERMCAP_me="$(printf '\033[0m')" \
        LESS_TERMCAP_se="$(printf '\033[0m')" \
        LESS_TERMCAP_so="$(printf '\033[1;44;33m')" \
        LESS_TERMCAP_ue="$(printf '\033[0m')" \
        LESS_TERMCAP_us="$(printf '\033[1;32m')" \
        man "$@"
}

path_lines() {
    local value_name=${1:-PATH}
    local value
    value=${!value_name}
    printf '%s\n' "$value" | tr ':' '\n'
}

open_path() {
    case "$(uname -s 2>/dev/null)" in
        Darwin)
            command open "${@:-.}"
            ;;
        Linux)
            command xdg-open "${1:-.}"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            command cmd.exe /c start "" "$(cygpath -w "${1:-.}")"
            ;;
        *)
            printf '%s\n' 'open_path: unsupported platform' >&2
            return 1
            ;;
    esac
}
