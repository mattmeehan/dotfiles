#!/usr/bin/env bash
#
# This script will
# - Download and install Homebrew on macOS, and brew various formulae
# - Install system packages on Linux
# - Change default shell to zsh
# - Download and install Oh My Zsh
# - Symlink all `*.symlink` files into $HOME as dotfiles
# - Download & install vim-plug and then install plugins

set -x

# Are we on macOS or Linux?
OS=$(uname -s)
DOTFILES=$(pwd)

# macOS-specific
if [ "$OS" = "Darwin" ]; then
  # Install homebrew
  printf "\nInstalling Homebrew...\n"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  BREW_FORMULAE='./brew/formulae.txt'
  BREW_FORMULAE_HEAD='./brew/formulae-head.txt'
  # Install brew formulae
  printf "Installing Homebrew formulae from '$BREW_FORMULAE' and '$BREW_FORMULAE_HEAD'..."
  xargs brew install <$BREW_FORMULAE
  xargs brew install --HEAD <$BREW_FORMULAE_HEAD
# Linux specific
else
  # System packages
  printf "Add linux-specific instructions"
fi


printf "\nInstalling pyenv...\n"

if [ ! -d ~/.pyenv ]
then
	# Install pyenv
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
	git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
	git clone https://github.com/pyenv/pyenv-update.git $PYENV_ROOT/plugins/pyenv-update
	git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv
	export PATH="$HOME/.pyenv/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
	pyenv install 3.12 && pyenv global 3.12
else
	export PATH="$HOME/.pyenv/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
	pyenv rehash
fi

printf "\nChanging shell to zsh...\n"
# NOTE: You may have to run the following:
#   sudo printf $(which zsh) >> /etc/shells`
chsh -s $(which zsh)

printf "\nInstalling oh-my-zsh...\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

printf "\nSymlinking '*.symlink' files...\n"
# Function to create symlink
create_symlink() {
    ln -sv "$SOURCE_FILE" "$LINK_FILE"
    echo "Symlink created from $SOURCE_FILE to $LINK_FILE."
}

for SOURCE_FILE in $(find $(pwd) -name '*.symlink'); do
  LINK_FILE="$HOME/.$(basename ${SOURCE_FILE%.symlink})"
  # Check if the link file already exists
  if [ -e "$LINK_FILE" ]; then
    # Prompt the user for action
    read -p "$LINK_FILE already exists. Do you want to overwrite it? (y/n): " user_input
    if [[ "$user_input" = "y" || "$user_input" = "Y" ]]; then
	  rm $LINK_FILE
      create_symlink
    else
      echo "Operation cancelled."
    fi
  else
    create_symlink
  fi
done


printf "\nDone!"
