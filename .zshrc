# Set Unicode format, but is not necessary
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Disable vi mode [-e], to enable [-v], default always works Emacs mode
bindkey -e

source $HOME/.colors.sh

# Install and star zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# Install and star starship
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

# Add plugins in zsh
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add snippets in zsh
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Completion config
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --icon=always $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# env
export VISUAL=nvim
export EDITOR=nvim
export SUDO_PROMPT="passwd: "

# Aliases
alias ls='lsd --group-dirs=first'
alias cat='bat --theme=OneHalfDark -P -p'
alias catp='bat --theme=OneHalfDark -p'
alias catn='bat --theme=OneHalfDark --style=numbers'
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"
alias grep="grep --color=auto"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
