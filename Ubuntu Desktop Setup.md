## Ubuntu Desktop Setup

These are the steps I follow upon setting up a fresh Ubuntu 16.04 Desktop.

### Install Google Chrome

16.04 has a bug in the out-of-the-box software installer, so you can't install chrome unless you do this first:

```
sudo apt-get autoremove gnome-software &&
sudo apt-get install -y gnome-software
```

Then you can download & install [Google Chrome](https://www.google.com/chrome/), come back to this page, login, and follow the rest of the steps. :)

### Generate a Keypair

Each machine should have it's own unique keypair. You should _never_ copy a private key anywhere.

This snippet will generate a new keypair (if one doesn't already exist).

```
[ ! -e ~/.ssh/id_rsa.pub ] &&
sudo apt-get update -y &&
sudo apt-get install -y openssh-client &&
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P '' -q &&
eval "$(ssh-agent -s)" &&
ssh-add ~/.ssh/id_rsa &&
echo "Your public key is:\n\n" &&
cat ~/.ssh/id_rsa.pub
```

You can then use the _public key_ to access yout [github](https://github.com/settings/keys) or [gitlab](https://gitlab.com/profile/keys) account.

### Stop `sudo` asking for password

	echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER-sudo-nopasswd
	sudo chmod 0440 /etc/sudoers.d/$USER-sudo-nopasswd

### Ubuntu Desktop Settings

	System Settings -> Appearance -> Behavior -> Auto-Hide the Launcher: ON
	System Settings -> Appearance -> Behavior -> Reveal Sensitivity: Low
	System Settings -> Appearance -> Behavior -> Enable Workspaces
	System Settings -> Appearance -> Behavior -> Show the menus for a window: [tick] In the window's title bar
	System Settings -> Brightness & Lock -> Turn screen off when inactive for: 10 minutes
	System Settings -> Security & Privacy -> Diagnostics -> [untick] Send error reports to Canonical
	System Settings -> Security & Privacy -> Diagnostics -> [untick] Send occasional system information to Canonical
	System Settings -> Text Entry -> [untick] Show current input source in the menu bar
	System Settings -> Bluetooth -> [untick] Show bluetooth status in the menu bar
	System Settings -> Screen Display -> Arrange your screens
	System Settings -> Screen Display -> Launcher Placement: (Primary)
	System Settings -> Screen Display -> Sticky Edges: OFF
	System Settings -> Software & Updates -> Additional Drivers -> (Use latest video drivers if current ones have tearing)
	System Settings -> Time & Date -> Clock -> [tick] Seconds

### Creating your own Keyboard Shortcuts to run Bash Scripts

For Build Scripts, or whatever.

- System Settings -> Keyboard -> Shortcuts -> Custom Shortcuts -> [+]
- Name: `on_hotkey`
- Command: `dotfiles/dotfiles.sh hotkey`
- Highlight the line, and press the `Disabled` dialogue
- Press the Key Combination (I use the `Pause` key)

To use: run `on_hotkey <your command>` on the CLI.

### Uninstall Bloatware

	sudo apt-get purge -y thunderbird* unity-lens-music unity-lens-video unity-lens-photos unity-scope-audacious unity-scope-manpages unity-scope-calculator unity-scope-musicstores unity-scope-chromiumbookmarks unity-scope-musique unity-scope-clementine unity-scope-openclipart unity-scope-colourlovers unity-scope-devhelp unity-scope-texdoc unity-scope-firefoxbookmarks unity-scope-tomboy unity-scope-gdrive unity-scope-video-remote unity-scope-gmusicbrowser unity-scope-virtualbox unity-scope-gourmet unity-scope-yelp unity-scope-guayadeque unity-scope-zotero
	unity-webapps-* && sudo updatedb

## Change Alt+Tab Behavior

	- Install `Unity Tweak Tool`

		Overview -> Switcher -> [untick] `Display "Schow Desktop" icon`

## Make Terminals look Nicer

TODO: Doesn't work any more :(

`nano ~/.config/gtk-3.0/gtk.css`:

```
TerminalWindow .notebook tab:active {
    background-color: #def;
}
```


## Install Flux

Optional, but it'll save your eyes!

https://gist.github.com/deanrather/b547e486d58612c87c6a2e2a0bc876b8
