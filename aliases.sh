#!/bin/bash

# Workstation
alias ws="workstation"
alias wr="workstation reload"
alias wp="workstation push && workstation pull"

# Vagrant
alias v="vagrant"
alias vup="vagrant up"
alias vssh="vagrant ssh"

# Git
alias g="git"
alias gp="git push && git pull"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch && git fetch --tags"
alias gb="git_branch"
alias ga="git add ."
alias gc="git commit -am"

# Edit
alias edit="vim"
alias e="edit"
alias ea="edit ~/.workstation.d/aliases.sh"
alias eg="edit ~/.gitrc"
alias et="edit ~/.tmux.conf"
alias ev="edit ~/.vimrc"
alias ew="edit ~/.workstation.sh"

# Other
alias i="sudo apt-get install -y"
alias locate="sudo updatedb; locate"

