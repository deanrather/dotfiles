#!/bin/bash
# Workstation Configurator

    # To execute script, run:
    # 
    #   wget -O ~/.workstation https://gist.githubusercontent.com/deanrather/5719199/raw && cat ~/.workstation | bash
    # 
    # This will run the one-off setup, and install itself into the profile.


## CONFIGURATION ##

### Git configuration
    # git_user_name=
    # git_user_email=

### Packages to install
    # package_list="git tig vim tree"

### Configure history to automatically save
    # avoid duplicates
    # export HISTCONTROL=ignoredups:erasedups  
    # append history entries
    # shopt -s histappend
    # After each command, save and reload history
    # export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
    # Causes pressing UP to show the previous command run in other terminal...

    export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
    export HISTSIZE=100000                   # big big history
    export HISTFILESIZE=100000               # big big history
    shopt -s histappend                      # append to history, don't overwrite it

    # Save and reload the history after each command finishes
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

### Configure history to save with timestamp
    HISTTIMEFORMAT="%Y-%m-%d %T "

### Bash Prompt Colour
    # https://wiki.archlinux.org/index.php/Color_Bash_Prompt
    export BLACK='\e[0;30m'
    export RED='\e[0;31m'
    export GREEN='\e[0;32m'
    export YELLOW='\e[0;33m'
    export BLUE='\e[0;34m'
    export PURPLE='\e[0;35m'
    export CYAN='\e[0;36m'
    export WHITE='\e[0;37m'
    export RESET='\e[0;00m'
    # .bashrc colour options:
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    # .bashrc default:
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

## FUNCTIONS ##

### workstation_reload function
    # reloads the .workstation file
    # usage: workstation_reload
    workstation_reload()
    {
        source ~/.workstation
    }

### log function
    # writes logs to ~/.workstation.log/
    # eg: echo "hello world" | log
    # eg: echo "hello world" | log mylog.log
    log()
    {
        read message
        [ -d ~/.workstation.log ] || mkdir ~/.workstation.log
        [ -z "$1" ] && log_basename='workstation.log' || log_basename="$1"
        log_path=~/.workstation.log/"$log_basename"
        touch "$log_path"
        date=$(date +%F\T%T%z | sed 's/^.\{22\}/&:/')
        pid=$$
        echo -e "$date $pid $message" >> "$log_path"
    }
    
### slowdots function
    # Displays 3 dots over 3 seconds to give the user a chance to read
    # Usage: echo "get ready" | slowdots
    slowdots()
    {
        read line
        echo -n "$line"
        for i in 1 2 3
        do
            echo -n "."
            sleep 1
        done
        echo ""
    }
    
### github_tinyurl function
    # Generates a GitHub Tiny URL
    # Usage: github_tinyurl https://gist.github.com/deanrather/5572701
    github_tinyurl()
    {
        local url=$1
        curl -o- -i -s http://git.io -F "url=$url" | grep "Location" | awk '{print $2}'
    }
    
    google()
    {
        google-chrome "https://www.google.com.au/search?q=$1&btnl=1"
    }

    # Makes ALT+C Copy the current line
    copy-current-line()
    {
        local current_line="${READLINE_LINE:0:$READLINE_POINT}${CLIP}${READLINE_LINE:$READLINE_POINT}"
        echo -n "$current_line" | xclip
    }
    bind -m emacs -x '"\ec": copy-current-line'

    copy-last-command()
    {
        fc -ln -1 | sed 's/^ *//' | xclip                            # copies to middle-click-paste
        # fc -ln -1 | sed 's/^ *//' | xclip -selection clipboard     # copies to regular paste
    }

    # Get current host related info.
    # http://www.tldp.org/LDP/abs/html/sample-bashrc.html
    function ii()
    {
        echo -e "\nYou are logged on ${BRed}$HOST"
        echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
        echo -e "\n${BRed}Users logged on:$NC " ; w -hs | cut -d " " -f1 | sort | uniq
        echo -e "\n${BRed}Current date :$NC " ; date
        echo -e "\n${BRed}Machine stats :$NC " ; uptime
        echo -e "\n${BRed}Memory stats :$NC " ; free
        echo -e "\n${BRed}Diskspace :$NC " ; mydf / "$HOME"
        echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
        echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
        echo
    }


## OTHER SCRIPTS ##
    
    # Source any scripts in the ~/.workstation.sh directory
    [ -d ~/.workstation.d ] || mkdir ~/.workstation.d
    for file in ~/.workstation.d/*
    do
        source "$file";
    done


## SETUP ##

    # This will only be executed when run via the Wget command,
    # It is not executed when loaded as part of the profile
    # if [ "$0" = "bash" ]
    # then
    #     echo "Checking git details"
    #     [ -z "$git_user_name" ]  || ( echo -n "Git Name: ";  read git_user_name  )
    #     [ -z "$git_user_email" ] || ( echo -n "Git Email: "; read git_user_email )

    #     # echo "Installing Packages: $package_list" | slowdots
    #     # sudo apt-get update -y
    #     # sudo apt-get install $package_list -y

    #     echo "Configuring Git"
    #     git config --global user.name "$git_user_name"
    #     git config --global user.email "$git_user_email"
    #     git config --global color.ui true
    #     git config --global push.default matching

    #     echo "Configuring Tig"
    #     touch ~/.tigrc
    #     grep -q "color date"         ~/.tigrc || echo "color date         white black" >> ~/.tigrc
    #     grep -q "color graph-commit" ~/.tigrc || echo "color graph-commit red   black" >> ~/.tigrc

    #     echo "Configuring Vim"
    #     touch ~/.vimrc
    #     grep -q "set background" ~/.vimrc || echo "set background=dark"      >> ~/.vimrc
    #     grep -q "set tabstop"    ~/.vimrc || echo "set tabstop=4"            >> ~/.vimrc
    #     grep -q "map <F5>"       ~/.vimrc || echo "map <F5> :!php -l %<CR>"  >> ~/.vimrc
    #     grep -q "set autoindent" ~/.vimrc || echo "set autoindent"           >> ~/.vimrc

    #     echo "Configuring Profile"
    #     grep -q "~/.workstation" ~/.bashrc || echo -e "\n[ -f ~/.workstation ] && . ~/.workstation" >> ~/.bashrc
    #     . ~/.profile
        
    #     echo "Configured as $git_user_name with ~/.workstation"
    # fi


## TODO ##

    # Autocompletions:
    #   http://tldp.org/LDP/abs/html/tabexpansion.html
    #   _ssh_hosts=$(grep "Host " ~/.ssh/config | awk '{print $2}')
    #   complete -W "$_ssh_hosts" myfunction
    # Help / Documentation - Reflection?
    #   http://stackoverflow.com/questions/2630812/
    # Push / Pull Script
    # Generate Key
    # Fix Setup determining


## NOTES ##

    # Bash Manual:        http://linux.die.net/man/1/bash
    # Sublime Setup:      https://gist.github.com/deanrather/2885590
    # Keyboard Shortcuts: https://gist.github.com/deanrather/2915320
    # Using Vim:          https://gist.github.com/deanrather/7310797
    # Using Git:          https://gist.github.com/deanrather/5572701
    # Using VimDiff:      https://gist.github.com/mattratleph/4026987

