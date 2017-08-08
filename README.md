# Dotfiles

These are my dotfiles. There are many like them, but these are mine.

This repo is designed to:

- setup an ubuntu desktop just the way I like it
- setup an ubuntu server just the way I like it
- allow me to easy to quickly add and change things
- allow me to easy to sync settings between multiple machines
- allow other developers to easily fork, modify, and use themselves

It does not:

- contain any personally identifyable stuff (you're welcome to use it as-is!)
- change any core default behavior (i.e. stuff that might mess up other things)

## How's it work?

There's 3 major parts to it:

- The Setup Script -- this uses Salt to install and configure a bunch-o-programs
- The Fuction Toolkit -- several utility functions that are helpfult to keep around
- The Preferences -- settings, aliases, etc.


## Setup

(optional) Fork this repo into your own account using the `Fork` button.

Clone the repo into `~/dotfiles` and run:

	~/dotfiles/setup.sh

Or, here's some copy-pasta if you're into that kind of thing:

```
read -e -p "Github repo: " -i "deanrather/dotfiles" GITHUB_REPO &&
which git >> /dev/null || sudo apt-get install -y git &&
git clone "https://github.com/$GITHUB_REPO.git" ~/dotfiles &&
~/dotfiles/setup.sh
```

## TOOD

- finish fixing up the salt vs scripts vs functinos stuff
- make sure to `sudo apt install linux-image-extra-$(uname -r) linux-image-extra-virtual`
- incorperate Toolkit
- get best fns from loveguy's scripts
- update w/ thanks to loveguy
- travis?
- get the correct / latest docker+compose

## See Also

- [Ubuntu Desktop Setup](Ubuntu Desktop Setup.md)
- [Sublime Setup](https://gist.github.com/deanrather/2885590)
- [Dotfiles](http://github.com/dotfiles)
- [Bash Manual](http://linux.die.net/man/1/bash)
- [Keyboard Shortcuts](https://gist.github.com/deanrather/2915320)
- [Using Vim](https://gist.github.com/deanrather/7310797)
- [Using Git](https://gist.github.com/deanrather/5572701)
- [Using VimDiff](https://gist.github.com/mattratleph/4026987)
