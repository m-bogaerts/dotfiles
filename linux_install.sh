#!/usr/bin/env bash

# linux_install.sh — Shell software installation script
# Created by m-bogaerts (https://github.com/m-bogaerts/dotfiles)

cd "$(dirname "${BASH_SOURCE}")";

echo "Shell installation script for m-bogaerts' dotfiles";
echo "-------------------------------------------------";
echo "";

showInfo() {
	echo "";
	echo "[INFO] I'll update your repository caches and perform the installation of required software.";
	echo "[WARNING] This script has been thought to run with APT-like distributions.";
}

installSoftware() {
	# Install zsh and required software
	echo "[INFO] Installing required software (zsh, git, curl, wget and python-pip)...";
	sudo apt-get install -y zsh git-core curl wget fonts-hack-ttf

	# Change the shell to zsh
	echo "[INFO] Changing the shell of this user to use zsh...";
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

updateApt() {
	echo "[INFO] Updating APT repositories...";
	sudo apt-get update;
}

syncConfig() {
	echo "[INFO] Syncing configuration...";
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude ".gitignore" --exclude "linux_install.sh" \
	--exclude "osx_install.sh" --exclude "README.md" --exclude "LICENSE" -avh --no-perms . ~;

}

doIt() {
	updateApt;
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
