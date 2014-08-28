# Workstation Configurator
# To execute script, run:
# 
#   wget -O ~.workstation https://dl.dropboxusercontent.com/u/1574931/.workstation.sh?raw && cat ~/.workstation | bash
# 
# This script installs itself into the profile environment, providing various functionality.
# It contains a "Configuration" block which is only executed when the wget line is used.


### CONFIGURATION ###

# Git Configuration
git_user_name=
git_user_email=

# Packages to install
package_list="git tig vim tree"

# Configure history to automatically save
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Configure history to save with timestamp
HISTTIMEFORMAT="%Y-%m-%d %T "


### FUNCTIONS ###

# Displays 3 dots over 3 seconds to give the user a chance to read
# Usage: echo "get ready" | slowdots
slowdots()
{
  read line
  echo -n "$line"
  for i in 1 2 3
  do
    echo -n "."
    sleep 1
  done
  echo ""
}


### CONFIGURATION ###

# This will only be executed when run via the Wget command,
# It is not executed when loaded as part of the profile
if [ "$0" = "bash" ]
then
  
  echo "checking git details"
  [ -z "$git_user_name" ] || ( echo -n "Git Name: "; read git_user_name )
  [ -z "$git_user_email" ] || ( echo -n "Git Email: "; read git_user_email )

  # echo "Installing Packages: $package_list" | slowdots
  # sudo apt-get update -y
  # sudo apt-get install $package_list -y

  echo "Configuring Git"
  git config --global user.name "$git_user_name"
  git config --global user.email "$git_user_email"
  git config --global color.ui true
  git config --global push.default matching

  echo "Configuring Tig"
  touch ~/.tigrc
  grep -q "color date"         ~/.tigrc || echo "color date         white black" >> ~/.tigrc
  grep -q "color graph-commit" ~/.tigrc || echo "color graph-commit red   black" >> ~/.tigrc

  echo "Configuring Vim"
  touch ~/.vimrc
  grep -q "set background" ~/.vimrc || echo "set background=dark"      >> ~/.vimrc
  grep -q "set tabstop"    ~/.vimrc || echo "set tabstop=4"            >> ~/.vimrc
  grep -q "map <F5>"       ~/.vimrc || echo "map <F5> :!php -l %<CR>"  >> ~/.vimrc
  grep -q "set autoindent" ~/.vimrc || echo "set autoindent"           >> ~/.vimrc

  echo "Configuring Profile"
  grep -q "~/.workstation" ~/.bashrc || echo -e "\n[ -f ~/.workstation ] && . ~/.workstation" >> ~/.bashrc
  . ~/.workstation
  
  echo "Configured as $git_user_name with ~/.workstation"
fi


### TODO ###

# http://linux.die.net/man/1/bash
# complete -F _ssh test2.sh

# vimdiff file1 file2
# CTRL-W h        move to the window on the left
# CTRL-W j        move to the window below
# CTRL-W k        move to the window above
# CTRL-W l        move to the window on the right
