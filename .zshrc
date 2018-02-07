#######################################
# Oh My ZSH settings
#######################################

export ZSH=/home/joel/.oh-my-zsh
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
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8

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
alias ssh-do="ssh -p 24999 the-eyes@192.241.191.66"
alias ssh-vpn="ssh root@172.93.52.234"
alias ssh-ssd="ssh joel@172.93.54.61"
alias ssh-ground="ssh joelh221@77.104.161.221 -p18765 -i ~/.ssh/id_rsa"

alias _="sudo -E"

alias dnf="sudo dnf"

#######################################
# Bullet Train settings
#######################################

BULLETTRAIN_PROMPT_ORDER=(
  time
  dir
  git
)

#BULLETTRAIN_TIME_BG=7
#BULLETTRAIN_TIME_FG=8
#BULLETTRAIN_STATUS_FG=15
#BULLETTRAIN_CONTEXT_FG=15
#BULLETTRAIN_DIR_FG=15
#BULLETTRAIN_GIT_BG=0
#BULLETTRAIN_GIT_FG=15

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
