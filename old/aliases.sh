#!/bin/bash


# Dotfiles
alias ds="dotfiles"
alias dr="dotfiles reload"
alias dp="dotfiles pull && dotfiles push"
alias dv="dotfiles version"


# Docker
alias docker-npm="docker run --rm -v $PWD:/app/ -w /app/ -it node npm"
alias docker-node="docker run --rm -v $PWD:/app/ -w /app/ -it node node"
alias docker-env="docker run --rm -v $PWD:/app/ -w /app/ -it node bash"
alias docker-rm-dangling-volumes='docker volume rm $(docker volume ls -qf dangling=true)'
alias docker-rm-dangling-images='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias docker-rm-exited-containers='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'
alias docker-kill-all-containers='docker kill $(docker ps -qa)'
alias docker-rm-all-containers='docker rm $(docker ps -qa)'
alias docker-rm-all-images='docker rmi $(docker images -qa)'
alias docker-rm-everything='docker-kill-all-containers; docker-rm-dangling-volumes; docker-rm-dangling-images; docker-rm-exited-containers; docker-rm-all-containers; docker-rm-all-images'
alias docker-run-prev-image='docker run -it --rm "$(docker images -q | head -n 1)"'
alias docker-rerun-prev-container='prev_container_id="$(docker ps -aq | head -n1)" && docker commit "$prev_container_id" "prev_container/$prev_container_id" && docker run -it "prev_container/$prev_container_id"'
alias dc="docker-compose"
alias dps="docker ps"


# Vagrant
alias v="vagrant"
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vs="vagrant status"
alias vr="vagrant reload"
alias vp="vagrant provision"


# Git
alias g="git"
alias gp="git pull --no-edit --all --tags && git push && git push --tags"
alias gs="git status"
alias gd="git diff"
alias git_diff_ignore_whitespace="git diff --ignore-all-space"
alias gf="git fetch --all --tags"
alias gb="git_branch"
alias ga="git add "
alias gc="git commit"
alias ta="tig --all"
alias gsu="git submodule update --init --recursive"
alias gm="git merge -Xignore-space-change"
alias git_no_merged="git branch -a --no-merged"
alias git_logs_nice="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias git_current_commit="git rev-parse HEAD"

# Tmux
alias t="tmux"
alias ta="tmux attach"


# NPM
alias npmi="npm install"
alias npmig="npm install --global"
alias npmis="npm install --save"
alias npmisd="npm install --save --dev"


# Edit
alias edit="vim"
alias e="edit"
alias ea="edit ~/dotfiles-autoload/aliases.sh && dr"
alias eg="edit ~/.gitrc"
alias et="edit ~/.tmux.conf && tmux source ~/.tmux.conf"
alias ev="edit ~/.vimrc"
alias ed="edit ~/dotfiles/dotfiles.sh"

# History
alias he="history -a" # export history
alias hi="history -n" # import history

# Other
alias i="sudo apt-get install -y"
alias locate="sudo updatedb; locate"
alias explorer="nautilus"
