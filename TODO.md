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

# note: not a huge fan of this after all... I'd rather just have bash scripts...



### Sublime

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &&
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list &&
sudo apt-get update &&
sudo apt-get install sublime-text


### Google Chrome

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - &&
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' &&
sudo apt-get update &&
sudo apt-get install -y google-chrome-stable


### Dropbox

sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E &&
sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main" &&
sudo apt-get update &&
sudo apt-get install -y dropbox


### NodeJS

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &&
sudo apt-get install -y nodejs &&
mkdir -p ~/.npm-global &&
npm config set prefix '~/.npm-global' &&
export PATH=~/.npm-global/bin:$PATH &&
source ~/.profile &&
node --version &&
npm --version


### Drivers for exfat usbs and sd cards

sudo apt-get update &&
sudo apt-get install -y exfat-utils exfat-fuse
