### VARS
EMAIL="dom.hutton@gmail.com"
NAME="Dom Hutton"
### DEPENDENCIES
sudo apt-get install stow git xclip gpg curl tmux jq htop build-essential file --yes

### SSH
yes y | ssh-keygen -t rsa -b 4096 -C "${EMAIL}" -f ~/.ssh/id_rsa -N ""
echo "########################################################"
echo "Public SSH key material"
echo "########################################################"
cat ~/.ssh/id_rsa.pub
read -n 1 -s -r -p 'Press any key to continue';echo

### KEYBASE
if ! [ -x "$(command -v keybase)" ]; then
  echo "########################################################"
  echo "Installing Keybase"
  echo "########################################################"
  curl -O https://prerelease.keybase.io/keybase_amd64.deb
  sudo dpkg -i keybase_amd64.deb
  sudo apt-get install -f --yes
  rm -f keybase_amd64.deb
fi
echo "########################################################"
echo "About to run keybase"
echo "Login and add the device, then press any key to continue this script"
echo "########################################################"
run_keybase
read -n 1 -s -r -p 'Press any key to continue';echo

### GPG
keybase pgp export | gpg --import
keybase pgp export --secret | gpg --allow-secret-key --import
KEY=$(gpg --list-secret-keys --keyid-format short | grep sec | cut -d ' ' -f 4 | cut -d '/' -f 2)
echo "########################################################"
echo "You are about to edit key ${KEY} and trust it ultimately"
echo "When prompted, input 'trust', followed by '5', 'y' to confirm then 'quit' to continue script."
echo "########################################################"
gpg --edit-key ${KEY}

echo "########################################################"
echo "Public GPG key material"
echo "It is on your clipboard too, paste it into github.com/settings/gpg/new (if this is a key rotation)"
echo "########################################################"
gpg --armor --export ${KEY}
gpg --armor --export ${KEY} | xclip -sel clip
echo "########################################################"
echo "Public GPG key material is on your clipboard, paste it into github.com/settings/gpg/new (if this is a key rotation)"
echo "########################################################"
read -n 1 -s -r -p 'Press any key to continue';echo

### GIT
git config --global user.signingkey ${KEY}
git config --global commit.gpgsign true
git config --global user.email "${EMAIL}"
git config --global user.name "${NAME}"
git config --global alias.up 'pull --rebase --autostash'
git config --global pull.rebase true
git config --global rebase.autoStash true

git config --global push.default current

### DEVEX
### caps for ctrl
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
### terminal keybindings
cat ./gnome-terminal/org-gnome-terminal-legacy-keybindings.txt | dconf load /org/gnome/terminal/legacy/keybindings/
cat ./gnome-terminal/org-gnome-terminal-legacy-menu-accelerator-enabled.txt | dconf load /org/gnome/terminal/legacy/
cat ./gnome-terminal/org-gnome-settings-daemon-plugins-media-keys.txt | dconf load /org/gnome/settings-daemon/plugins/media-keys/
### workspaces span multi-monitor congifs (who thought this was a good idea)
gsettings set org.gnome.mutter workspaces-only-on-primary "false"

### vscodium editor
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
sudo apt-add-repository 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main'
sudo apt update
sudo apt install codium
### vscodium base extensions
codium --install-extension k--kato.intellij-idea-keybindings

### bash-it
echo "########################################################"
echo "Installing bash-it"
echo "########################################################"
git clone --depth=1 https://github.com/Bash-it/bash-it.git ./bash_it

### RVM
echo "########################################################"
echo "Installing RVM (not supported by brew sadly) - might take a while to validate gpg"
echo "########################################################"
gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable


### STOW
stow --adopt --target=${HOME} tmuxinator
stow --adopt --target=${HOME} tmux
stow --adopt --target=${HOME} rvm
stow --adopt --target=${HOME} yarn
stow --adopt --target=${HOME} git
stow --adopt --target=${HOME} bash
stow --adopt --target=${HOME} mozilla
stow --adopt --target=/usr/lib/firefox mozilla-firefox-bin # Needs sudo
stow --adopt --target=${HOME} gcloud
# stow --target=${HOME} aws_vault
# stow --target=${HOME} ssh_helper_gnome_extension
# stow --target=${HOME} yubikey

### BREW
# Note: May need to configure terminal emulator to run shell as login
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
brew tap homebrew/bundle
brew bundle

### Finishing Up
### Checkout was not possible over SSH, now it is so let's drop back to SSH remote
git remote set-url origin git@github.com:Dombo/dotfiles.git