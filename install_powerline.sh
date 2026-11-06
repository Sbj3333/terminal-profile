#!/usr/bin/env bash
# Fail on any command.
set -euxo pipefail
cd "$(dirname "$0")"

# Install Powerline (Python package + VIM bindings) and its symbol fonts.
# Newer Ubuntu blocks `pip install --user` (PEP 668), so use the apt packages.
sudo apt install -y powerline python3-powerline fonts-powerline
cp configs/.vimrc ~/.vimrc

# Install Patched Font for the current user.
mkdir -p ~/.local/share/fonts
cp -a fonts/RobotoMono/*.ttf ~/.local/share/fonts/
fc-cache -f ~/.local/share/fonts
