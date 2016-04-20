# Dotfiles

TODO: Info about these dotfiles.

## Setup

Just clone this repo into `~/dotfiles` and run:

	~/dotfiles/workstation.sh setup

Here's some copy-pasta if you're into that kind of thing:

```
read -e -p "Github repo: " -i "deanrather/dotfiles" GITHUB_REPO &&
sudo apt-get update -y &&
sudo apt-get install -y git &&
git clone "https://github.com/$GITHUB_REPO.git" ~/dotfiles &&
~/dotfiles/workstation.sh setup
```
