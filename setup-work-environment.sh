#!/usr/bin/env bash
# bash <(curl -s https://gist.githubusercontent.com/deanrather/5719199/raw/gistfile1.txt)
git_user_name="Dean Rather"
git_user_email="deanrather@gmail.com"

echo "Setting up Git"
git config --global user.name $git_user_name
git config --global user.email $git_user_email
git config --global color.ui true

echo "Installing and setting up Tig"
sudo apt-get install tig
echo "color date              white   black" > ~/.tigrc
echo "color graph-commit      red     black" >> ~/.tigrc

echo "Setting up Vim"
echo "set background=dark"      > ~/.vimrc
echo "set tabstop=4"            >> ~/.vimrc
#echo "set autoindent"           >> ~/.vimrc
echo "map <F5> :!php -l %<CR>"  >> ~/.vimrc

#echo "Install elinks"
#sudo apt-get install elinks

echo "Retaining Bash History"
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# TODO
# http://askubuntu.com/questions/391082/how-to-see-time-stamps-in-bash-history
# http://linux.die.net/man/1/bash

# echo "setting up: \"google <keyword>\" support"
# sudo apt-get install sr
# alias google='sr google' # needs to go in .profile or .bash_aliases or something

echo "This is now $git_user_name's Work Environment."
