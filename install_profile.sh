#!/usr/bin/env bash
# Fail on any command.
set -euxo pipefail
cd "$(dirname "$0")"

# Install plug-ins (you can git-pull to update them later).
plugins_dir=~/.oh-my-zsh/custom/plugins
[ -d "$plugins_dir/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugins_dir/zsh-syntax-highlighting"
[ -d "$plugins_dir/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"

# Replace the configs with the saved one (back up any existing .zshrc first).
if [ -f ~/.zshrc ] && ! cmp -s configs/.zshrc ~/.zshrc; then
	cp ~/.zshrc ~/.zshrc.pre-pixegami
fi
cp configs/.zshrc ~/.zshrc

# Copy the modified Agnoster Theme
cp configs/pixegami-agnoster.zsh-theme ~/.oh-my-zsh/themes/pixegami-agnoster.zsh-theme

profile_id=fb358fc9-49ea-4252-ad34-1d25c649e633

if command -v ptyxis >/dev/null; then
	# Ptyxis (default terminal since Ubuntu 25.10).
	ptyxis_id=${profile_id//-/}
	mkdir -p ~/.local/share/org.gnome.Ptyxis/palettes
	cp configs/pixegami.palette ~/.local/share/org.gnome.Ptyxis/palettes/pixegami.palette

	profile_path=/org/gnome/Ptyxis/Profiles/$ptyxis_id/
	dconf write "${profile_path}label" "'Pixegami'"
	dconf write "${profile_path}palette" "'pixegami'"
	dconf write "${profile_path}opacity" "0.97"
	dconf write "${profile_path}login-shell" "false"
	dconf write /org/gnome/Ptyxis/use-system-font "false"
	dconf write /org/gnome/Ptyxis/font-name "'Roboto Mono for Powerline 14'"

	list_key=/org/gnome/Ptyxis/profile-uuids
	default_key=/org/gnome/Ptyxis/default-profile-uuid
	list_id=$ptyxis_id
else
	# GNOME Terminal.
	dconf load /org/gnome/terminal/legacy/profiles:/:$profile_id/ < configs/terminal_profile.dconf
	list_key=/org/gnome/terminal/legacy/profiles:/list
	default_key=/org/gnome/terminal/legacy/profiles:/default
	list_id=$profile_id
fi

# Add it to the profile list (once) and make it the default.
old_list=$(dconf read "$list_key" | tr -d "[]")
if [[ "$old_list" != *"'$list_id'"* ]]; then
	if [ -z "$old_list" ]; then
		new_list="['$list_id']"
	else
		new_list="[$old_list, '$list_id']"
	fi
	dconf write "$list_key" "$new_list"
fi
dconf write "$default_key" "'$list_id'"

# Switch the shell.
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
	chsh -s "$(command -v zsh)"
fi
