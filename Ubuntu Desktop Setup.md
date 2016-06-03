## Ubuntu Desktop Setup

### Stop `sudo` asking for password

	echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER-sudo-nopasswd
	sudo chmod 0440 /etc/sudoers.d/$USER-sudo-nopasswd

### Ubuntu Desktop Settings

	System Settings -> Appearance -> Behavior -> Auto-Hide the Launcher: ON
	System Settings -> Appearance -> Behavior -> Reveal Sensitivity: Low
	System Settings -> Appearance -> Behavior -> Enable Workspaces
	System Settings -> Appearance -> Behavior -> Show the menus for a window: [tick] In the window's title bar
	System Settings -> Bluetooth -> [untick] Show bluetooth status in the menu bar
	System Settings -> Brightness & Lock -> Turn screen off when inactive for: 1 hour
	System Settings -> Security & Privacy -> Search -> Include online search results: OFF
	System Settings -> Security & Privacy -> Diagnostics -> [untick] Send error reports to Canonical
	System Settings -> Security & Privacy -> Diagnostics -> [untick] Send occasional system information to Canonical
	System Settings -> Text Entry -> [untick] Show current input source in the menu bar
	System Settings -> Time & Date -> Clock -> [tick] Seconds

### Creating your own Keyboard Shortcuts to run Bash Scripts

For Build Scripts, or whatever.

- System Settings -> Keyboard -> Shortcuts -> Custom Shortcuts -> [+]
- Name: `hotkey.sh`
- Command: `/home/NAME/dotfiles/hotkey.sh`
- Highlight the line, and press the `Disabled` dialogue
- Press the Key Combination (I use the `Pause` key)

### Uninstall Bloatware

	sudo apt-get purge -y thunderbird* unity-lens-music unity-lens-video unity-lens-photos unity-scope-audacious unity-scope-manpages unity-scope-calculator unity-scope-musicstores unity-scope-chromiumbookmarks unity-scope-musique unity-scope-clementine unity-scope-openclipart unity-scope-colourlovers unity-scope-devhelp unity-scope-texdoc unity-scope-firefoxbookmarks unity-scope-tomboy unity-scope-gdrive unity-scope-video-remote unity-scope-gmusicbrowser unity-scope-virtualbox unity-scope-gourmet unity-scope-yelp unity-scope-guayadeque unity-scope-zotero
	unity-webapps-* && sudo updatedb

## Change Alt+Tab Behavior

	- Install `Unity Tweak Tool`

		Overview -> Switchboard -> [untick] `Display "Schow Desktop" icon`

## Make Terminals look Nicer

`nano ~/.config/gtk-3.0/gtk.css`:

```
TerminalWindow .notebook tab:active {
    background-color: #def;
}
```


## Install Flux

Optional, but it'll save your eyes!

```
git clone https://github.com/Kilian/f.lux-indicator-applet.git
cd f.lux-indicator-applet
sudo python setup.py install
sudo apt-get install python-pip
sudo -E pip install pexpect
sudo apt-get install -y python-gconf python-glade2 python-appindicator
fluxgui &
```
