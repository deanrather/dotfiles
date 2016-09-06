#!/bin/bash -e
# setup.sh
# sets up dotfiles.sh to auto-load with the terminal
# TODO: better description


# Install server packages
packages="$(cat ~/dotfiles/packages-server.txt)"
if apt-cache policy $packages | grep 'Installed: (none)' > /dev/null
then
    export DEBIAN_FRONTEND=noninteractive
    echo "Installing:"
    echo "$packages"
    sudo apt-get update
    sudo apt-get install -y $packages
fi

source ~/dotfiles/functions.sh
install_tmux_2

# Install desktop packages
if xset q &>/dev/null
then
   pip install --user powerline-status
   install_powerline_fonts
   packages="$(cat ~/dotfiles/packages-desktop.txt)"
    if apt-cache policy $packages | grep 'Installed: (none)' > /dev/null
    then
        export DEBIAN_FRONTEND=noninteractive
        echo "Installing:"
        echo "$packages"
        sudo apt-get update
        sudo apt-get install -y $packages
    fi
fi


# Configure Git
if [ ! "$1" == '--anon' ]
then
  if [ -z "$(git config --global user.name)" ]
  then
      echo -n "Git user name (The name to appear on your commits): "
      read git_user_name
      git config --global user.name "$git_user_name"
  fi

  if [ -z "$(git config --global user.email)" ]
  then
      echo -n "Git user email (The email to appear on your commits): "
      read git_user_email
      git config --global user.email "$git_user_email"
  fi
fi
git config --global include.path ~/dotfiles/git.conf


# Symlink config files
echo "Symlinking config files"
backup_symlink ~/dotfiles/tig.conf                          ~/.tigrc
backup_symlink ~/dotfiles/vim.conf                          ~/.vimrc
backup_symlink ~/dotfiles/tmux.conf                         ~/.tmux.conf
backup_symlink ~/dotfiles/terminator.conf                   ~/.config/terminator/config
backup_symlink ~/dotfiles/Package\ Control.sublime-settings "/home/$USER/.config/sublime-text-3/Packages/User/Package Control.sublime-settings"
backup_symlink ~/dotfiles/Preferences.sublime-settings      ~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings


# Setup & symlink autoloads
echo "Making ~/.dotfiles-autolod dir, symlinking aliases and functions"
[ -d ~/dotfiles-autoload ] || mkdir ~/dotfiles-autoload
[ -e ~/dotfiles-autoload/functions.sh ] || ln -s ~/dotfiles/functions.sh ~/dotfiles-autoload/functions.sh
[ -e ~/dotfiles-autoload/aliases.sh ]   || ln -s ~/dotfiles/aliases.sh   ~/dotfiles-autoload/aliases.sh
[ -e ~/dotfiles-autoload/prompt.sh ]   || ln -s ~/dotfiles/prompt.sh   ~/dotfiles-autoload/prompt.sh
[ -e ~/dotfiles-autoload/banner.sh ]   || ln -s ~/dotfiles/banner.sh   ~/dotfiles-autoload/banner.sh


# Setup dotfiles to autoload
echo "Configuring Profile"
grep -q "dotfiles.sh" ~/.bashrc || echo -e "\n[ -f ~/dotfiles/dotfiles.sh ] && . ~/dotfiles/dotfiles.sh" >> ~/.bashrc


# Done!
echo 'dotfiles is configured!'
echo -en "reload your profile to begin using:\n\n\tsource ~/.profile\n\n"
echo -en "see:\n\tdotfiles help\n\n"
