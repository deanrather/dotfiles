#!/bin/bash
# Workstation Configurator

    # To setup this script, run:
    # 
    #   wget -O ~/.workstation https://gist.githubusercontent.com/deanrather/5719199/raw && . ~/.workstation update
    # 
    # This achieves a few things:
    # - Installation & Setup of Programs (Interactive)
    # - Provides ~/.workstation file which automatically loads function library
    # - Provides ~/.workstation.d directory for auto-loading your own scripts
    # 
    # This script has been designed to demonstrate lots of various bash functionality,
    # and to include annotated examples, and references where appropriate.
    # 
    # For help, run:
    #   
    #   workstation help
    

## CONFIGURATION ##

### Packages to install
    package_list="git tig vim tree xclip xdotool"

### Configure History to automatically save
    export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
    export HISTSIZE=100000                   # big big history
    export HISTFILESIZE=100000               # big big history
    shopt -s histappend                      # append to history, don't overwrite it

    # Save and reload the history after each command finishes
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

### Configure history to save with timestamp
    HISTTIMEFORMAT="%Y-%m-%d %T "

### Bash Prompt Colour
    export BLACK='\e[0;30m'
    export RED='\e[0;31m'
    export GREEN='\e[0;32m'
    export YELLOW='\e[0;33m'
    export BLUE='\e[0;34m'
    export PURPLE='\e[0;35m'
    export CYAN='\e[0;36m'
    export WHITE='\e[0;37m'
    export RESET='\e[0;00m'
    # .bashrc colour:
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # .bashrc default:
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    # https://wiki.archlinux.org/index.php/Color_Bash_Prompt

### Generating Help
    # This saves a list of defined functions to the variable
    # It will be compared to a list we'll make futher down,
    # so we can know which functions were defined.
    functions_before=$(compgen -A function)

## MISC FUNCTIONS ##

### log function
    # writes logs to ~/.workstation.log/
    # eg: echo "hello world" | log
    # eg: echo "hello world" | log mylog.log
    log()
    {
        # Read message from STDIN
        read message
        # If dir does not exist, create it
        [ -d ~/.workstation.log ] || mkdir ~/.workstation.log
        # Set provide default value for first argument
        [ -z "$1" ] && log_basename='workstation.log' || log_basename="$1"
        # Concatenate dir with basename 
        log_path=~/.workstation.log/"$log_basename"
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
        
### enter_to_cancel function
    # displays "Press [ENTER] to cancel..."
    # returns true after a 4 second timeout,
    # or false if the user presses enter
    # eg:
    #   echo "about to do the thing"
    #   if enter_to_cancel
    #   then
    #       echo "doing the thing"
    #   fi
    enter_to_cancel()
    {
        # Display the message with the appended instructions 
        echo -n "Press [ENTER] to cancel"
        # Give them some more time
        for i in 1 2 3 4
        do
            # If it's not the first second, display a dot
            [ "$i" -gt 1 ] && echo -n "."
            # Wait 1 second, if the user enters something return false
            read -t 1 && return 1
        done
        # display a newline
        echo ""
        # nothing was pressed, return true
        return 0
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
    
    function find-function-definition()
    {
        # Turn on extended shell debugging
        shopt -s extdebug
        # Get the line number defined on
        line=$(echo $(declare -F $1) | awk '{print $2}')
        # Get the file defined in
        file=$(echo $(declare -F $1) | awk '{print $3}')
        # Turn off extended shell debugging
        shopt -u extdebug
        echo "$file +$line"
    }
    
    function get_newer_items()
    {
        old_list=$1
        new_list=$2
        new_items=$(
            diff -a             \
            <(echo "$old_list")  \
            <(echo "$new_list")   \
            | grep ">"             \
            | awk '{print $2}'
        )
        echo "$new_items"
    }

### Generating Help
    # This saves a list of defined functions to the variable
    # It will be compared to a list we'll make futher down,
    # so we can know which functions were defined.
    functions_plus_misc=$(compgen -A function)

    # echo "BEFORE: $functions_plus_misc"
    # echo "NOW: $functions_now"


## OTHER SCRIPTS ##
    
    # Source any scripts in the ~/.workstation.sh directory
    [ -d ~/.workstation.d ] || mkdir ~/.workstation.d
    if [ "$(ls -A ~/.workstation.d)" ]
    then
        for script in ~/.workstation.d/*
        do
            source "$script"
        done
    fi
    
    other_scripts=$(get_newer_items $original_function_list $(compgen -A function))

echo $other_scripts
## SETUP ##

    # This is only executed when run with the wget command at the top of the script,
    # or when passing in the "setup" argument.
    # It is not run when auto-loaded by your profile.
    if [ "$1" = "setup" ]
    then
        
        # Install packages
        # Uses sed to find/replace spaces with space-comma.
        echo "Installing packages: $(echo $package_list | sed 's/ /, /g')"
        if enter_to_cancel 
        then
            sudo apt-get update -y
            sudo apt-get install $package_list -y
        else
            echo "Package install cancelled"
        fi

        if [ -z "$(git config --global user.name)" ]
        then
            echo -n "Git user name: "
            read git_user_name
            git config --global user.name "$git_user_name"
        fi
        
        if [ -z "$(git config --global user.email)" ]
        then
            echo -n "Git user email: "
            read git_user_email
            git config --global user.email "$git_user_email"
        fi
        
        echo "Configuring Git"
        git config --global color.ui true
        git config --global push.default matching

        echo "Configuring Tig"
        touch ~/.tigrc
        grep -q "color date"         ~/.tigrc || echo "color date         white black" >> ~/.tigrc
        grep -q "color graph-commit" ~/.tigrc || echo "color graph-commit red   black" >> ~/.tigrc

        echo "Configuring Vim"
        touch ~/.vimrc
        grep -q "set background" ~/.vimrc || echo "set background=dark"      >> ~/.vimrc
        grep -q "set tabstop"    ~/.vimrc || echo "set tabstop=4"            >> ~/.vimrc
        grep -q "map <F5>"       ~/.vimrc || echo "map <F5> :!php -l %<CR>"  >> ~/.vimrc
        
        echo "Configuring Profile"
        grep -q "~/.workstation" ~/.bashrc || echo -e "\n[ -f ~/.workstation ] && . ~/.workstation" >> ~/.bashrc
         
        echo "$(git config --global user.name) configured"
        echo -e "see:\n\tworkstation help\n"
    fi

## WORKSTATION FUNCTIONS ##

    workstation()
    {
        if [ "$1" = "help" ]
        then
            cat ~/.workstation
        fi
        
        if [ "$1" = "setup" ]
        then
            bash ~/.workstation setup
        fi
        
        if [ "$1" = "reload" ]
        then
            echo "reloading ~/.workstation"
            source ~/.workstation
        fi
    }


## TODO ##

    # Autocompletions:
    #   http://tldp.org/LDP/abs/html/tabexpansion.html
    #   _ssh_hosts=$(grep "Host " ~/.ssh/config | awk '{print $2}')
    #   complete -W "$_ssh_hosts" myfunction
    # Help / Documentation - Reflection?
    #   http://stackoverflow.com/questions/2630812/
    # Push / Pull Script
    # Generate Key


## NOTES ##


    # Bash Manual:        http://linux.die.net/man/1/bash
    #   http://www.tldp.org/LDP/Bash-Beginners-Guide/html/Bash-Beginners-Guide.html
    # Sublime Setup:      https://gist.github.com/deanrather/2885590
    # Keyboard Shortcuts: https://gist.github.com/deanrather/2915320
    # Using Vim:          https://gist.github.com/deanrather/7310797
    # Using Git:          https://gist.github.com/deanrather/5572701
    # Using VimDiff:      https://gist.github.com/mattratleph/4026987
