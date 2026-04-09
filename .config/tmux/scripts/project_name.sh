#!/bin/sh

set -eu

print_unknown() {
    printf 'ROOT ?\n'
}

path_arg=${1-}

if [ -z "$path_arg" ] || [ ! -d "$path_arg" ]; then
    print_unknown
    exit 0
fi

if command -v git >/dev/null 2>&1; then
    git_root=$(git -C "$path_arg" rev-parse --show-toplevel 2>/dev/null || true)
    if [ -n "$git_root" ] && [ -d "$git_root" ]; then
        printf '%s\n' "$(basename "$git_root")"
        exit 0
    fi
fi

printf '%s\n' "$(basename "$path_arg")"
