# A script to simplify initiating distrobox-based containers.

# Install dependencies
dnf -y install zsh git nodejs

# Install CLI tooling
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# chmod 755 ~/.oh-my-zsh
chown joel:joel ~/.oh-my-zsh
curl -fsSL https://starship.rs/install.sh | sh -s -- -y
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Set up 1Password SSH Agent
if [[ ! -d ~/.ssh ]]; then
  mkdir ~/.ssh
  cd ~/.ssh
  cat <<EOF >>config
Host *
  IdentityAgent /var/home/joel/.1password/agent.sock
EOF
  cd ~
fi
chown joel:joel ~/.ssh

# Set up Zsh symlink to replicate environment
ln -sf /var/home/joel/src/dotfiles/.zshrc ~/.zshrc
ln -sf /var/home/joel/src/dotfiles/.zsh_exports ~/.zsh_exports
ln -sf /var/home/joel/src/dotfiles/.zsh_aliases ~/.zsh_aliases
mkdir ~/.config
ln -sf /var/home/joel/.config/starship.toml ~/.config/starship.toml
# chmod 755 ~/.config
chown joel:joel ~/.config

# Git setup
ln -sf /var/home/joel/src/dotfiles/.gitconfig ~/.gitconfig
ln -sf /var/home/joel/src/dotfiles/.gitconfig-linux ~/.gitconfig-linux

# Node.js setup
mkdir ~/.npm-global
chown joel:joel ~/.npm-global
npm config set prefix '~/.npm-global'
npm install -g corepack
chown joel:joel ~/.npmrc
