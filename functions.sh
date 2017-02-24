#!/bin/bash
# functions.sh
# misc functions to help with your workstation.
# wget https://raw.githubusercontent.com/deanrather/dotfiles/master/functions.sh && source functions.sh

# execute a command and display stderr in red
color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
colour()(color $@)


# Writes a log to ~/dotfile-logs/
# Usage: echo <message> | log [<logfile name>]
# eg: echo "hello world" | log
# eg: echo "hello world" | log mylog.log
log()
{
    local message
    local date
    local pid
    local log_path

    # If there are no args
    if [ $# -eq 0 ]
    then
      # Read message from STDIN
      read message
    else
      # get message from args
      message="$*"
    fi

    # If dir does not exist, create it
    [ -d ~/dotfile-logs ] || mkdir ~/dotfile-logs

    log_basename=dotfiles.log

    # Concatenate dir with basename
    log_path=~/dotfile-logs/"$log_basename"

    # Create logfile if it doesn't exist
    touch "$log_path"

    # Get current time in ISO8601 format
    # eg: 2014-08-29T19:01:46+10:00
    date=$(date +%F\T%T%z | sed 's/^.\{22\}/&:/')

    # Get process ID
    pid=$$

    # Append message to log file
    echo "$date $pid $message" >> "$log_path"
}

# Writes a log to ~/dotfile-logs/
# Usage: echo <message> | log [<logfile name>]
# eg: echo "hello world" | log
# eg: echo "hello world" | log mylog.log
log2()
{
    local message
    # Read message from STDIN
    read message
    # If dir does not exist, create it
    [ -d ~/dotfile-logs ] || mkdir ~/dotfile-logs
    # Set provide default value for first argument
    [ -z "$1" ] && log_basename='dotfiles.log' || log_basename="$1"
    # Concatenate dir with basename
    local log_path=~/dotfile-logs/"$log_basename"
    # Create logfile if it doesn't exist
    touch "$log_path"
    # Get current time in ISO8601 format
    # eg: 2014-08-29T19:01:46+10:00
    local date=$(date +%F\T%T%z | sed 's/^.\{22\}/&:/')
    # Get process ID
    local pid=$$
    # Append message to log file
    echo "$date $pid $message" >> "$log_path"
}


# Backs up a file (creates a copy in the same dir with <name>__<timestamp>.bak)
# eg: /path/to/file.zip becomes /path/to/file.zip__2016-04-20_05-32-25.bak
# Usage: backup /path/to/file
backup()
{
    cp "$1" "$1__$(date +%Y-%m-%d_%H-%M-%S).bak"
}

# If a file exists, backs it up and removes the original.
# Usage: backup /path/to/file
backup_remove()
{
    if [ -e "$1" ]
    then
        backup "$1"
        rm "$1"
    fi
}

# Symlink, but backup existing files first.
# Usage: backup_symlink /path/from/file /path/to/file
backup_symlink()
{
    backup_remove "$2"
    mkdir -p "$(dirname "$2")"
    ln -s "$1" "$2"
}


# usage: on_hotkey <command>
# eg: on_hotkey echo hello
# eg: on_hotkey ./test.sh
# For hotkey setup see: Ubuntu Desktop Setup.md
# For implementation see: dotfiles.sh:_dotfiles_hotkey
on_hotkey()
{
    # hotkey_file is written each time the hotkey is pressed
    hotkey_file=/tmp/dotfiles-hotkey.log

    # this script runs until closed with ctrl+c
    while true
    do

        # clear any existing hotkey file
        rm -f $hotkey_file

        # wait until a hotkey file exists
        while [ ! -e $hotkey_file ]
        do
            sleep 0.1
        done;

        # run your command
        eval "$@"
    done

}



# Executes a command repeatedly
# usage: repeat <command> [<frequency in seconds>]
#   CTRL+c to quit
# eg: repeat date
# Note that this is similar to `watch`
repeat()
{
    echo "TODO. fix me"; return
    local command=$1           # command is first arg
    local frequency=${2:-1}    # frequency is second arg or "1"

    clear

    trap ctrl_c INT            # catch ctrl+c keypress
    function ctrl_c
    {
        clear
        tput cnorm              # put the cursor back to normal
        return
    }

    while [ true ]              # Repeat forever
    do
        tput civis              # hide the cursor
        tput cup 0 0            # put cursor at top-left
        $command                # execute the command
        sleep $frequency        # wait for frequency
    done
}


# Watches a directory (recursively) for changes
# If any files within the directory change, executes command
# Usage: execute_on_change <dir> <command>
# eg: execute_on_change /tmp "echo yep"
execute_on_change()
{
    # see also: https://gist.github.com/senko/1154509
    local path="$1"
    local command="$2"
    local current_hash=""
    local new_hash=""
    while [[ true ]]
    do
        new_hash="$(find "$path" -type f | md5sum)"
        if [[ $old_hash != $new_hash ]]
        then
            $command
            old_hash=$new_hash
        fi
        sleep 2
        echo "hash: $new_hash"
    done
}

args_example_1()
{
  local apple=false
  local banana=false

  for arg in "$@"
  do
    case $arg in
      -a|--apple) apple=true ;;
      -b|--banana) banana=true ;;
      *) echo "unknown argument: $arg" ;;
    esac
  done

  echo "apple: $apple"
  echo "banana: $banana"
}

# Displays "Press [ENTER] to cancel..."
# Returns:
#   true after a 4 second timeout
#   false if the user presses enter
# eg:
#   echo "about to do the thing"
#   if enter_to_cancel
#   then
#       echo "doing the thing"
#   fi
enter_to_cancel()
{
    # Display the message
    echo -n "Press [ENTER] to cancel"
    # Give them some time to read
    local i
    for i in 1 2 3 4
    do
        # If it's not the first second, display a dot
        [ "$i" -gt 1 ] && echo -n "."
        # Wait 1 second, if the user enters something return false
        read -t 1 && return 1
    done
    # end the line
    echo
    # nothing was pressed, return true
    return 0
}


# Get internet IP address
getip_public()
{
    curl http://ipecho.net/plain
    echo
}

# Get local IP address
# Usage: getip [<interface name>]
getip()
{
    # interface provided as $1, defaults to "eth0"
    local interface=${1:-eth0}
    ifconfig "$interface" | grep -oP '(?<=inet addr:).*?(?= )'
    # -o                    # output the match
    # -P                    # use pearl regex
    # (?<=PATTERN)          # begin selection after this pattern
    # .*?                   # select everything until first match
    # (?=PATTERN)           # end selection before this pattern
}

# Sets a static IP address
# Backs up existing interfaces file
# Usage: setip <fourth IP tuplet> [<interface>]
# eg: setip 99
# eg: setip 50 wlan0
setip()
{
    local path="/etc/network/interfaces"
    # TODO: Error if no $1 is passed

    local interface=${2:-eth0}
    # TODO:
    #   - detect the list of interfaces
    #   - if only 1; use that; otherwise throw error
    #   ifconfig -s -a | awk '{print $1}'

    # Get the existing IP address parts
    local p1 p2 p3 p4
    read p1 p2 p3 p4 <<< $(getip "$interface" | tr "." "\n")

    # Set the fourth tuplet to that provided
    p4=$1

    # Backup existing file
    sudo cp "$path"{,.bak}

    # Write new file
    sudo sh -c "echo 'auto lo'                              > $path"
    sudo sh -c "echo 'iface lo inet loopback'              >> $path"
    sudo sh -c "echo ''                                    >> $path"
    sudo sh -c "echo 'auto $interface'                     >> $path"
    sudo sh -c "echo 'iface $interface inet static'        >> $path"
    sudo sh -c "echo '    address $p1.$p2.$p3.$p4'         >> $path"
    sudo sh -c "echo '    network $p1.$p2.$p3.0'           >> $path"
    sudo sh -c "echo '    netmask 255.255.255.0'           >> $path"
    sudo sh -c "echo '    broadcast $p1.$p2.$p3.255'       >> $path"
    sudo sh -c "echo '    dns-nameservers $p1.$p2.$p3.255' >> $path"
    sudo sh -c "echo '    gateway $p1.$p2.$p3.1'           >> $path"
    echo "IP address $p1.$p2.$p3.$p4 written to $path"

    # Restart the network
    # TODO: Only restart specific interface
    echo "Restarting network"
    if enter_to_cancel
    then
        sudo ifdown -a
        sudo ifup -a
    fi
}


# Creates a new branch
# Usage: git_branch <branchname>
git_branch()
{
    echo "git checkout -b $1"
    git checkout -b $1

    echo "git push -u origin $1"
    git push -u origin $1
}

git_tagrc_push()
{
	git_tagrc
	git push & git push --tags
}

git_tagrc()
{
	# todo: check clean

	VERSION=$(git branch | grep -Po '\* release/.+' | cut -d / -f 2)
	if [ -z "$VERSION" ]
	then
		echo "Error: not on a release branch."
		return 1
	fi

	PRERELEASE=0
	if git tag | grep -Po "v$VERSION-\d+"
	then
		PRERELEASE=$(git tag | grep -Po "v$VERSION-\d+" | sort | tail -n 1 | cut -d '-' -f 2)
	fi
	NEW_PRERELEASE=$((PRERELEASE+1))
	NEW_VERSION="$VERSION-$NEW_PRERELEASE"

	sed -i "s/\"version\":\s\"\w\.\w\.\w-*\w*\"/\"version\": \"$NEW_VERSION\"/" package.json
	git add package.json
	git commit -m "new release candidate: v$NEW_VERSION"
	git tag "v$NEW_VERSION"
	echo -e "push with:\n\n\tgit push & git push --tags\n"
}

git_bump()
{
  date > bump.txt &&
  git add bump.txt &&
  git commit -am "bump" &&
  git push
}

# Rename a remote git branch
# Usage: git_rename_remote_branch <oldbranch> <newbranch>
git_rename_remote_branch()
{
    # Thanks https://github.com/sschuberth/dev-scripts/blob/master/git/git-rename-remote-branch.sh
    if [ $# -ne 3 ]; then
        echo "Rationale : Rename a branch on the server without checking it out."
        echo "Usage     : git_rename_remote_branch <remote> <old name> <new name>"
        echo "Example   : git_rename_remote_branch origin master release"
        return 1
    fi

    echo "Renaming $1 $2 -> $3..."
    git push "$1" "$1/$2:refs/heads/$3" ":$2"
}

# Return true/false whether a repo is clean
# Usage: git_repo_is_clean </path/to/repo>
git_repo_is_clean()
{
    repo="$1"

    cd "$repo"
    if [[ -n $(git status --porcelain) ]]
    then
        echo "repo is dirty";
        return 1
    fi
}

# Delete a remote git branch
# Usage: git_delete_remote_branch <branchname>
git_delete_remote_branch()
{
    branchname="$1"
    git push origin --delete "$branchname"
}

# Shows the diff of changes to be merged in
# Usage: git_preview_merge <branchname>
git_preview_merge()
{
    branchname="$1"
    git diff --ignore-all-space "...origin/$branchname"
}

__git_complete git_preview_merge _git_checkout


git_status_merged()
{
  git status

  echo "merged:"
  git branch -a --merged

  echo "no-merged:"
  git branch -a --no-merged
}


# Run a program in the background
# Usage: run_in_background <command>
run_in_background()
{
    $@ > /dev/null 2>&1 &
    echo "Job running in background with pid: $!"
}

# Shortens a GitHub URL
# Usage: github_shortenurl <github url> [<code>]
github_shortenurl()
{
    # TODO:
    # - Warn if url looks like a commit instead of a head
    # - Warn if no /raw part on the end
    # - Output only the new URL if it worked

    local long_url short_url code orl_arg code_arg response

    if [ -n "$1" ]
    then
        long_url="$(echo $1 | sed 's/githubusercontent/github/g')"
    else
        describe_function "$FUNCNAME"
        return 1
    fi

    if [ -n "$2" ]
    then
        curl -o- -i -s http://git.io -F "url=$long_url" -F "code=$2"
    else
        curl -o- -i -s http://git.io -F "url=$long_url"
    fi

    echo
}

# Set the terminal title
set_term_title()
{
    echo -ne "\033]0;$1\007"
}


# Clone from github
# Usage: github_clone username/repo
github_clone()
{
    git clone git@github.com:/$1.git
}

# Clone from bitbucket
# Usage: bitbucket_clone username/repo
bitbucket_clone()
{
    git clone git@bitbucket.com:/$1.git
}

# Clone from gitlab
# Usage: gitlab_clone username/repo
gitlab_clone()
{
    git clone git@gitlab.com:/$1.git
}

# Add a remote to github
# Usage: github_add_remote username/repo
github_add_remote()
{
    git remote add github git@github.com:/$1.git
    git remote -v
    git fetch github
}

# Add a remote to bitbucket
# Usage: bitbucket_add_remote username/repo
bitbucket_add_remote()
{
    git remote add bitbucket git@bitbucket.com:/$1.git
    git remote -v
    git fetch bitbucket
}

# Add a remote to gitlab
# Usage: gitlab_add_remote username/repo
gitlab_add_remote()
{
    git remote add gitlab git@gitlab.com:/$1.git
    git remote -v
    git fetch gitlab
}


# Opens a google-chrome browser and googles for the query
# Usage: google <query>
# eg: google shell scripting
google()
{
    local command="google-chrome https://www.google.com.au/search?q=$1&btnl=1"
    run_in_background "$command"
}

# # Copies the current terminal line
# # Bound to ALT+C
# copy_current_line()
# {
#     local current_line="${READLINE_LINE:0:$READLINE_POINT}${CLIP}${READLINE_LINE:$READLINE_POINT}"
#     echo -n "$current_line" | xclip
# }
# bind -m emacs -x '"\ec": copy_current_line' || echo "unable to bind for copy-line"

# Copies the last command executed
copy_last_command()
{
    fc -ln -1 | sed 's/^ *//' | xclip                            # copies to middle-click-paste
    # fc -ln -1 | sed 's/^ *//' | xclip -selection clipboard     # copies to regular paste
}

# View active network connections
view_network()
{
    sudo lsof -i
}

# Displays a hash of a directory recursively
# Usage: hashdir <path/to/dir>
hashdir()
{
    local dir="$1"
    find "$dir" -type f -exec md5sum {} + | awk '{print $1}' | sort | md5sum
}

# Displays all the colours of the rainbow
colours()
{
    echo -e "\e[0;30m - txtblk";
    echo -e "\e[0;31m - txtred";
    echo -e "\e[0;32m - txtgrn";
    echo -e "\e[0;33m - txtylw";
    echo -e "\e[0;34m - txtblu";
    echo -e "\e[0;35m - txtpur";
    echo -e "\e[0;36m - txtcyn";
    echo -e "\e[0;37m - txtwht";
    echo -e "\e[1;30m - bldblk";
    echo -e "\e[1;31m - bldred";
    echo -e "\e[1;32m - bldgrn";
    echo -e "\e[1;33m - bldylw";
    echo -e "\e[1;34m - bldblu";
    echo -e "\e[1;35m - bldpur";
    echo -e "\e[1;36m - bldcyn";
    echo -e "\e[1;37m - bldwht";
    echo -e "\e[4;30m - unkblk";
    echo -e "\e[4;31m - undred";
    echo -e "\e[4;32m - undgrn";
    echo -e "\e[4;33m - undylw";
    echo -e "\e[4;34m - undblu";
    echo -e "\e[4;35m - undpur";
    echo -e "\e[4;36m - undcyn";
    echo -e "\e[4;37m - undwht";
    echo -e "\e[40m - bakblk";
    echo -e "\e[41m - bakred";
    echo -e "\e[42m - bakgrn";
    echo -e "\e[43m - bakylw";
    echo -e "\e[44m - bakblu";
    echo -e "\e[45m - bakpur";
    echo -e "\e[46m - bakcyn";
    echo -e "\e[47m - bakwht";
    echo -e "\e[0m - txtrst";
}

# takes a number between 0 - 100, returns that colour in a number
# 0  - 70  - green
# 71 - 80  - yellow
# 80 - 100 - red
colour_percentage()
{
    w="\e[0m"
    g="\e[0;32m";
    y="\e[0;33m";
    r="\e[0;31m";

    if   [ "$1" -lt "71" ]; then echo -en "$g$1%$w";
    elif [ "$1" -gt "80" ]; then echo -en "$r$1%$w";
    else                         echo -en "$y$1%$w"; fi
}

# Describes a function
# Usage: describe_function <function name>
# eg: describe_function display_final_block
describe_function()
{
    local function_name=$1

    # Turn on extended shell debugging
    shopt -s extdebug
    # Get the line number defined on
    local line_number="$(echo $(declare -F $1) | awk '{print $2}')"
    # Get the file defined in
    local file="$(echo $(declare -F $1) | awk '{print $3}')"
    # Turn off extended shell debugging
    shopt -u extdebug

    # tmp hax
    function_name="$(echo $function_name | sed 's/dotfiles_/dotfiles /g')"

    echo -en "\n\t$function_name\n"

    let "line_number-=1"
    local line
    head -n "$line_number" "$file" | tac | while read line
    do
        [[ "$line" ]] || break
        line="$(echo $line | sed 's/^# //')"
        # echo $line
        echo -en "\t\t$line\n"
    done | tac

    let "line_number+=1"
    echo -en "\t\t  > $file +${line_number}\n"
}

# Describes a list of functions
# Usage: describe_functions <function list> <list name>
describe_functions()
{
    local function_list=$1
    local function_list_name=$2
    echo -en "\n\n$function_list_name\n"
    local function_name
    echo "$function_list" | while read function_name
    do
        describe_function "$function_name"
    done
}



# Adds a keypair if one does not exist.
# Echo's out the public key in the format expected by add_remote_user (username, fullname, pubkey)
#
# Usage:
#
#    request_remote_user
#
request_remote_user()
{
    USERNAME="$USER"
    # todo: grep -e "^${USER}:" (because what if your usename is "d")
    FULLNAME="$(getent passwd | grep ^$USER: | cut -d':' -f5 | cut -d',' -f1)"

    if [ ! -e ~/.ssh/id_rsa.pub ]
    then
        sudo apt-get install -y ssh-keygen
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P '' -q
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_rsa
    fi

    PUBKEY="$(cat ~/.ssh/id_rsa.pub)"

    echo "add_remote_user \"$USERNAME\" \"$FULLNAME\" \"$PUBKEY\"";
}


# Adds a new user to the system, allowing access by the provided public key.
#
# Usage:
#
#    add_remote_user "<username>" "<Full Name>" "<Public Key>"
#
# eg:
#
#    add_remote_user "dean" "Dean Rather" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChab0m+uBRifnBEn8DGFc0rUWDtuMB93Z5lM9yKxO0SHN0e4Fhozv83LRxGThoWDl6jEFjaW2RqqbtSgCJQBnJrQDdKxeLgkLOz6FEWnQsvRsT71ngLSXUEKWhIfJS1D+Cur6q7CmiaZf86Yh3T2bsaqS2x0aWtWTd6ybLpqFATdEQrzJH1SYOGNe3uRx/hR9d3D3v20Azm2bhaQ4EteSdf11dGcRdmE4oQNPZXHLPtpZQMVpKbpNuuUMwddh/TPnnRq7WSU7ZAKDHPxPvlQRvqlq6xU0L8vl2pGvJhnJHg9ZZWZRcAMnLwu+Zh0vMtpOFnT4SUXlyWqqwjA1c9c9x dean@dean-XPS-8700"
#    add_remote_user d "Dean Rather" "$(wget -q -O - deanrather.com/pubkeys.txt)"
#
add_remote_user()
{
    USERNAME="$1"
    FULLNAME="$2"
    PUBKEY="$3"

	sudo adduser --quiet --disabled-password "$USERNAME" --gecos="$FULLNAME"
    sudo mkdir "/home/$USERNAME/.ssh"
    echo -n "Adding public key "
    echo "$PUBKEY" | sudo tee "/home/$USERNAME/.ssh/authorized_keys"
    sudo chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh/"

    grant_user_superpowers "$USERNAME"

    IPS="$(ifconfig | grep -Po 'inet addr:.+? ' | grep -v '127.0.0.1' | cut -d":" -f2)"
    echo -e "\n\n$FULLNAME can now access this machine as the user $USERNAME via one of the following IPs:"
    echo "$IPS"
    wget -q -O - icanhazip.com

    # TODO:
    # - Add validation for inputs
    # - Add error handling
}



# Sets the machine hostname
# Doesn't require reboot!
# http://askubuntu.com/a/516898/55141
set_hostname()
{
    sudo hostnamectl set-hostname "$1"
    echo "127.0.0.1    $1" | sudo tee -a /etc/hosts
}

# Allows a user root access without password
# Usage: grant_user_superpowers <username>
# eg: grant_user_superpowers dean
grant_user_superpowers()
{
    USERNAME="$1"
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$USERNAME-sudo-nopasswd"
	sudo chmod 0440 "/etc/sudoers.d/$USERNAME-sudo-nopasswd"
}



install_tmux_2()
{
	if ! tmux -V | grep 'tmux 2.0'
	then
		sudo apt-get update
		sudo apt-get install -y python-software-properties software-properties-common
		sudo add-apt-repository -y ppa:pi-rho/dev
		sudo apt-get update
		sudo apt-get install -y tmux
	fi
	echo "Current Tmux Version: $(tmux -V)"
}


install_powerline_fonts()
{
	cd /tmp
	wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
	mkdir -p ~/.fonts/
	mv PowerlineSymbols.otf ~/.fonts/
	fc-cache -vf ~/.fonts
	mkdir -p ~/.config/fontconfig/conf.d/
	mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
}

record_gif()
{
  ~/dotfiles/functions/record_gif.sh
}

is_online()
{
  IP="$1"
  echo -n "$IP is "
  if ping -c 1 "$IP" > /dev/null
  then
    echo "online"
  else
    echo "offline"
  fi
}

serve_current_dir()
{
    which browser-sync || npm i -g browser-sync
    sudo "$(which node)" "$(which browser-sync)" start --server --port 80
}

detect_ip_conflicts()
{
  sudo arp-scan -I eno1 -l
}

execute_remote_script()
{
  script_url="$1"
  shift # removes the first arg from the list of args
  curl -s "$script_url" | bash -s $@
}

install_atom()
{
  latest_page_url="https://github.com/atom/atom/releases/latest"
  echo "getting latest download url from $latest_page_url"
  html_file_path="$(mktemp)"
  curl --silent --location --output "$html_file_path" "$latest_page_url"

  uri="$(cat "$html_file_path" | grep '.deb' | grep 'href=' | cut -d '"' -f 2)"
  #url="https://github.com$uri"
  url="https://github.com$uri"
  echo "downloading latest package from: $url"
  download_dir="$(mktemp -d)"
  package_path="$download_dir/atom-amd64.deb"
  curl --location --progress-bar --output "$package_path" "$url"

  echo "installing from package: $package_path"
  sudo dpkg -i "$package_path"

  echo -e "latest atom installed\nuse:\n\n\tapm update\n\nto update atom's pacakges"
}

build_2gb_swapfile()
{
  if [ "$(wc -l < /proc/swaps)" == "1" ]
  then
   echo "Making Swapfile"
   sudo dd if=/dev/zero of=/.swap bs=1024 count=2M # 2GB Swapfile
   sudo mkswap /.swap
   echo "/.swap swap swap sw 0 0" | sudo tee -a /etc/fstab
   sudo chown root:root /.swap
   sudo chmod 0600 /.swap
   sudo swapon /.swap
  fi
}

# ---------------------------------

# Get list of misc functions defined
[[ "$misc_function_list" ]] ||
    misc_function_list=$(grep -Fxv -f \
        <(echo "$original_function_list") \
        <(compgen -A function))
