# Setting $PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/.npm-global/lib/node_modules:/var/lib/snapd/snap/bin:$PATH

# Path to the oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH theme to display.
ZSH_THEME="spaceship"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# History time stamps
HIST_STAMPS="yyyy-mm-dd"

# Oh-my-zsh plugins
plugins=( git docker cp zsh-syntax-highlighting )

# Spaceship settings
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_RPROMPT_ORDER=( time )
SPACESHIP_TIME_SHOW=true
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_USER_SHOW=true
SPACESHIP_DIR_SHOW=true

# Spaceship + Dracula
# Use `spectrum_ls` to get the loaded colors
SPACESHIP_DIR_COLOR=000
SPACESHIP_GIT_BRANCH_COLOR=004

# Sourcing oh-my-zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh_exports
source $HOME/.zsh_aliases
