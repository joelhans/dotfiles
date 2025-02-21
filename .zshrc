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

# kubectl completions
source <(kubectl completion zsh)

eval "$(direnv hook zsh)"
# eval "$(dircolors ~/.dircolors)"
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
