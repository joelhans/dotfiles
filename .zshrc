# Setting $PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export BMO_SOURCE=~/src/bmo-agent

# History settings: shared, immediate append, and larger size
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt share_history          # share history across sessions, write immediately
setopt extended_history       # timestamps in the history file

# Ignore history by putting a space in front of a command
setopt hist_ignore_all_dups
setopt hist_ignore_space
HISTORY_IGNORE="(clear|export *|* clear)"

source $HOME/.zsh_exports
source $HOME/.zsh_aliases
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

_gs() {
  local -a branches
  branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})
  _describe 'local branch' branches
}
compdef _gs gs

# antidote
source $HOME/.antidote/antidote.zsh
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

if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Zellij helpers
unalias zl 2>/dev/null
zl() {
  if [ $# -eq 0 ]; then
    command zellij list-sessions
  else
    command zellij attach "$@"
  fi
}

unalias zc 2>/dev/null
zc() {
  local exited autogen

  exited=$(command zellij list-sessions --no-formatting | awk '/EXITED/ {print $1}')
  if [[ -n "$exited" ]]; then
    printf "%s\n" "$exited" | xargs -n 1 command zellij delete-session
  else
    echo "No exited zellij sessions to delete."
  fi

  autogen=$(command zellij list-sessions --no-formatting | awk '!/EXITED/ {print $1}' | grep -E '^[a-z]+-[a-z]+$' | grep -vxF "${ZELLIJ_SESSION_NAME:-}")
  if [[ -n "$autogen" ]]; then
    printf "%s\n" "$autogen" | xargs -n 1 command zellij delete-session --force
  else
    echo "No auto-named zellij sessions to delete."
  fi
}

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

if [[ -z "$ZELLIJ" ]]; then
  zellij
fi
