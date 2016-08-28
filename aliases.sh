#!/bin/bash

# Workstation
alias ds="dotfiles"
alias dr="dotfiles reload"
alias dp="dotfiles pull && dotfiles push"
alias dv="dotfiles version"

# Docker
alias dnpm="sudo docker run --rm -v $PWD:/app/ -w /app/ -it node npm"
alias dnode="sudo docker run --rm -v $PWD:/app/ -w /app/ -it node node"
alias denv="sudo docker run --rm -v $PWD:/app/ -w /app/ -it node bash"
alias dps="sudo docker ps"

# Vagrant
alias v="vagrant"
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vs="vagrant status"
alias vr="vagrant reload"

# Git
alias g="git"
alias gp="git pull --no-edit --all --tags && git push && git push --tags"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch --all --tags"
alias gb="git_branch"
alias ga="git add "
alias gc="git commit"
alias ta="tig --all"
alias gsu="git submodule update --init --recursive"
alias gm="git merge -Xignore-space-change"
alias git_no_merged="git branch -a --no-merged"

# Edit
alias edit="vim"
alias e="edit"
alias ea="edit ~/dotfiles-autoload/aliases.sh && dr"
alias eg="edit ~/.gitrc"
alias et="edit ~/.tmux.conf && tmux source ~/.tmux.conf"
alias ev="edit ~/.vimrc"
alias ed="edit ~/dotfiles/dotfiles.sh"

# Other
alias i="sudo apt-get install -y"
alias locate="sudo updatedb; locate"
alias explorer="nautilus"
