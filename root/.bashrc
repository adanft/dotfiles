# Exit if not interactive
[[ $- != *i* ]] && return

# ===== Safety =====
set -o noclobber
set -o ignoreeof
shopt -s checkwinsize

# ===== History =====
HISTSIZE=10000
HISTFILESIZE=20000
HISTFILE="/root/.bash_history"
HISTCONTROL=ignoredups:erasedups
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# ===== Aliases =====
alias ls='ls --color=auto -F'
alias grep='grep --color=auto'

# ===== Environment =====
export EDITOR=nvim
export VISUAL=nvim
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# ===== Umask =====
umask 022

# ===== Colors =====
RED='\[\033[0;31m\]'
CYAN='\[\033[0;36m\]'
BLUE='\[\033[0;34m\]'
RESET='\[\033[0m\]'

# ===== Prompt =====
PS1="${RED}root${RESET}@${CYAN}\h${RESET}:${BLUE}\w${RESET}\n→ "

# ===== Terminal title + history sync =====
PROMPT_COMMAND='history -a; history -c; history -r; echo -ne "\033]0;root - ${PWD##*/}\007"'

# ===== Functions =====
mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

duh() {
    du -h --max-depth=1 2>/dev/null | sort -h
}

# ===== Warning =====
echo -e "\033[0;31m⚠  You are operating as ROOT ⚠\033[0m"
