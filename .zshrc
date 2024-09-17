# Setting $PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.npm-global/bin/:$PATH

# Path to the oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# History time stamps
HIST_STAMPS="yyyy-mm-dd"

# Oh-my-zsh plugins
plugins=( 1password copybuffer cp direnv docker git kubectl minikube toolbox zsh-syntax-highlighting )

# Sourcing oh-my-zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh_exports
source $HOME/.zsh_aliases

autoload -Uz compinit && compinit

eval "$(direnv hook zsh)"
# eval "$(dircolors ~/.dircolors)"
eval "$(starship init zsh)"
