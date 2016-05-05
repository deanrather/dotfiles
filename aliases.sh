#!/bin/bash

# Workstation
alias ds="dotfiles"
alias dr="dotfiles reload"
alias dp="dotfiles pull && dotfiles push"
alias dv="dotfiles version"

# Vagrant
alias v="vagrant"
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vs="vagrant status"
alias vr="vagrant reload"

# Git
alias g="git"
alias gp="git pull --no-edit && git push"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch && git fetch --tags"
alias gb="git_branch"
alias ga="git add ."
alias gc="git commit -am"
alias ta="tig --all"
alias gsu="git submodule update --init --recursive"

# Edit
alias edit="vim"
alias e="edit"
alias ea="edit ~/dotfiles-autoload/aliases.sh && wr"
alias eg="edit ~/.gitrc"
alias et="edit ~/.tmux.conf"
alias ev="edit ~/.vimrc"
alias ed="edit ~/dotfiles/dotfiles.sh"

# Other
alias i="sudo apt-get install -y"
alias locate="sudo updatedb; locate"
alias explorer="nautilus"
