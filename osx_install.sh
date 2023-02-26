#!/usr/bin/env bash

# osx_install.sh — OSX installation script
# Created by m-bogaerts (https://github.com/m-bogaerts/dotfiles)

cd "$(dirname "${BASH_SOURCE}")";

echo "Shell installation script for m-bogaerts' dotfiles";
echo "-------------------------------------------------";
echo "";

installSoftware() {
  # Install zsh and required software
  echo "[INFO] Installing required software (zsh, git, curl, wget...)";
  brew install git zsh curl wget coreutils gpg

  # Change the shell to zsh
  echo "[INFO] Changing the shell of this user to use zsh...";
  echo $(which zsh) | sudo tee -a /etc/shells
  chsh -s $(which zsh)

  # Install Oh My Zsh!
  echo "[INFO] Installing Oh My Zsh...";
  curl -L http://install.ohmyz.sh | sh
  echo "[INFO] Installing ZSH syntax highlighting...";
  rm -rf ~/.zsh-custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-custom/plugins/zsh-syntax-highlighting

  # Install powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh-custom/themes/powerlevel10k
}

installBrew() {
  if hash brew 2>/dev/null; then
    echo "[INFO] Brew already installed."
  else
    echo "[INFO] Installing Homebrew package manager...";
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

updateBrew() {
  if hash brew 2>/dev/null; then
    echo "[INFO] Updating Homebrew package manager...";
    brew update;
  fi
}

syncConfig() {
  echo "[INFO] Syncing configuration...";
  rsync --exclude ".git/" --exclude ".DS_Store" --exclude ".gitignore" --exclude "linux_base.sh" \
     --exclude "osx_base.sh" --exclude "README.md" --exclude "LICENSE" -avh --no-perms . ~;
}

doIt() {
  installBrew;
  updateBrew;
  installSoftware;
  syncConfig;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "I'm about to change the configuration files placed in your home directory. Do you want to continue? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;

echo "";
echo "[INFO] If there isn't any error message, the process is completed.";
