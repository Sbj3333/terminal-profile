#!/usr/bin/env bash
# Fail on any command.
set -euxo pipefail

# Install ZSH
sudo apt install -y git zsh curl

# Install OhMyZSH (skip if already installed). --unattended stops it from
# switching shells / launching zsh mid-script; install_profile.sh does chsh.
if [ ! -d ~/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
