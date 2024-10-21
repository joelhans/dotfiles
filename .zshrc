# Setting $PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# History time stamps
HIST_STAMPS="yyyy-mm-dd"

source $HOME/.zsh_exports
source $HOME/.zsh_aliases
source <(fzf --zsh)

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# Source zplug, then some plugins, then plugin configuration
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-history-substring-search"
zplug load --verbose
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ngrok completions
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

eval "$(direnv hook zsh)"
# eval "$(dircolors ~/.dircolors)"
eval "$(starship init zsh)"
