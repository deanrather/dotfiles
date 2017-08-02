# TODO

- Generate Key / SSH Agent
- Fix the repeat function
- http://ithaca.arpinum.org/2013/01/02/git-prompt.html
- Change all the helper functions to use gist and have the code separate
- Separate Desktop vs Server programs
- other inline TODOs
- https://github.com/bkuhlmann/dotfiles


New machine guide:

- install dotfiles
- set_hostname <hostname>
- `request_remote_user` on workstation
- `add_remote_user` on new machine
- `grant_user_superpowers` on new machine


install node:
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &&
sudo apt-get install -y nodejs &&
mkdir -p ~/.npm-global &&
npm config set prefix '~/.npm-global' &&
export PATH=~/.npm-global/bin:$PATH &&
source ~/.profile &&
node --version &&
npm --version
