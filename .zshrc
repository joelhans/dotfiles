# Setting $PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export BMO_SOURCE=~/src/bmo-agent

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# History time stamps
HIST_STAMPS="yyyy-mm-dd"

# Ignore history by putting a space in front of a command
setopt hist_ignore_all_dups
setopt hist_ignore_space
HISTORY_IGNORE="(clear|export *|* clear)"

source $HOME/.zsh_exports
source $HOME/.zsh_aliases
source <(fzf --zsh)

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# Source zplug, then some plugins, then plugin configuration
#source ~/.zplug/init.zsh
#zplug "zsh-users/zsh-history-substring-search", as:plugin
#zplug load --verbose
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down

# source antidote
source $HOME/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

# ngrok completions
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# k8s completions
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi
if command -v minikube &>/dev/null; then
  source <(minikube completion zsh)
fi

eval "$(direnv hook zsh)"
# eval "$(dircolors ~/.dircolors)"
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/joelhans/.lmstudio/bin"
alias python=python3
alias pip=pip3

# bun completions
[ -s "/var/home/joel/.bun/_bun" ] && source "/var/home/joel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
