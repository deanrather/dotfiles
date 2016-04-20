#!/bin/bash

# Workstation
alias ds="dotfiles"
alias dr="dotfiles reload"
alias dp="dotfiles push && workstation pull"

# Vagrant
alias v="vagrant"
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vs="vagrant status"

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
alias ea="edit ~/.workstation.d/aliases.sh && wr"
alias eg="edit ~/.gitrc"
alias et="edit ~/.tmux.conf"
alias ev="edit ~/.vimrc"
alias ew="edit ~/.workstation.git/.workstation.sh"

# Other
alias i="sudo apt-get install -y"
alias locate="sudo updatedb; locate"
alias explorer="nautilus"
