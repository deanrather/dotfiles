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


### allow exfat usbs and sd cards to work
sudo apt-get install exfat-utils exfat-fuse


### setup a read-only network shared folder

mkdir /shared
sudo chown -R nobody.nogroup /shared
sudo chmod -R 777 /shared
sudo vim /etc/samba/smb.conf

```
[shared]
path = /shared
guest ok = yes
```

sudo service smbd restart


### the salt stuff

~/dotfiles/salt-workstation v3$ make install
~/dotfiles/salt-workstation v3$ make apply
~/dotfiles/salt-workstation v3$ sudo salt-call state.apply --local --file-root=./state/ -l debug apps
~/dotfiles/salt-workstation v3$ sudo salt-call state.apply --local --file-root=./state/ -l debug
