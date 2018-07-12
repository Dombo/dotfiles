### VARS
EMAIL="dom.hutton@gmail.com"
NAME="Dom Hutton"
### DEPENDENCIES
sudo apt-get install stow git xclip gpg curl tmux jq htop rvm build-essential file --yes

### SSH
yes y | ssh-keygen -t rsa -b 4096 -C "${EMAIL}" -f ~/.ssh/id_rsa -N ""
echo "########################################################"
echo "Public SSH key material"
echo "It is on your clipboard too, paste it into github.com/settings/ssh/new"
echo "########################################################"
cat ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub | xclip -sel clip
read -n 1 -s -r -p 'Press any key to continue';echo

### KEYBASE
if ! [ -x "$(command -v keybase)" ]; then
  curl -O https://prerelease.keybase.io/keybase_amd64.deb
  sudo dpkg -i keybase_amd64.deb
  sudo apt-get install -f --yes
  rm -f keybase_amd64.deb
fi
run_keybase

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
read -n 1 -s -r -p 'Press any key to continue';echo

### GIT
git config --global user.signingkey ${KEY}
git config --global commit.gpgsign true
git config --global user.email "${EMAIL}"
git config --global user.name "${NAME}"
git config --global alias.up 'pull --rebase --autostash'
git config --global pull.rebase true
git config --global rebase.autoStash true

git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait $MERGED"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd "code --wait --diff $LOCAL $REMOTE"

### BREW
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
brew tap homebrew/bundle
brew bundle

### NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

### YARN
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --yes --no-install-recommends yarn

### STOW
 
stow --target=${HOME} tmuxinator
stow --target=${HOME} tmux
stow --target=${HOME} rvm
stow --target=${HOME} git
stow --target=${HOME} bash
# stow --target=${HOME} aws_vault
# stow --target=${HOME} ssh_helper_gnome_extension
# stow --target=${HOME} yubikey

### Helpers

# Clone all the repos belonging to a github organisation
# GITHUB_PAT=""
# GITHUB_ORGANISATION=""
# curl -u ${GITHUB_PAT}:x-oauth-basic -s \
#  https://api.github.com/orgs/${GIT_ORGANISATION}/repos?per_page=100 | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'
