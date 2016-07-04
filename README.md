# Dotfiles

TODO: Info about these dotfiles.

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

## See Also

- [Ubuntu Desktop Setup](Ubuntu Desktop Setup.md)
- [Dotfiles](http://github.com/dotfiles)
- [Bash Manual](http://linux.die.net/man/1/bash)
- [Sublime Setup](https://gist.github.com/deanrather/2885590)
- [Keyboard Shortcuts](https://gist.github.com/deanrather/2915320)
- [Using Vim](https://gist.github.com/deanrather/7310797)
- [Using Git](https://gist.github.com/deanrather/5572701)
- [Using VimDiff](https://gist.github.com/mattratleph/4026987)
