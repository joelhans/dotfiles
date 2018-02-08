#######################################
# Oh My ZSH settings
#######################################

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="spaceship"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
HIST_STAMPS="mm/dd/yyyy"
plugins=(git docker cp zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#######################################
# User configuration
#######################################

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nano'
fi

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Ensure 256 colors
export TERM="xterm-256color"

#######################################
# Set personal aliases.
#######################################

alias _="sudo -E"
alias dnf="sudo dnf"

#######################################
# Spaceship settings
#######################################

SPACESHIP_PROMPT_ORDER=(
  time
  user
  host
  dir
  git
)

# DOCKER
SPACESHIP_DOCKER_SHOW=false
