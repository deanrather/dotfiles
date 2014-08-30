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
    # and to include annotated examples, and references.
    # 
    # For help, run:
    #   
    #   workstation help
    

## CONFIGURATION ##

    # Packages to install
    package_list="git tig vim tree xclip xdotool"

    # Configure History to automatically save
    export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
    export HISTSIZE=100000                   # big big history
    export HISTFILESIZE=100000               # big big history
    shopt -s histappend                      # append to history, don't overwrite it

    # Save and reload the history after each command finishes
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

    # Configure history to save with timestamp
    export HISTTIMEFORMAT="%Y-%m-%d %T "

    # Bash Prompt Colour
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
    export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # .bashrc default:
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    # https://wiki.archlinux.org/index.php/Color_Bash_Prompt

    # Generating Help
    # This saves a list of defined functions to the variable
    # It will be compared to a list we'll make futher down,
    # so we can know which functions were defined.
    [[ "$original_function_list" ]] || original_function_list=$(compgen -A function)


## MISC FUNCTIONS ##

    # Writes a log to ~/.workstation.log/
    # Usage: echo <message> | log [<logfile name>]
    # eg: echo "hello world" | log
    # eg: echo "hello world" | log mylog.log
    log()
    {
        local message
        # Read message from STDIN
        read message
        # If dir does not exist, create it
        [ -d ~/.workstation.log ] || mkdir ~/.workstation.log
        # Set provide default value for first argument
        [ -z "$1" ] && log_basename='workstation.log' || log_basename="$1"
        # Concatenate dir with basename 
        local log_path=~/.workstation.log/"$log_basename"
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
    
    # Generates a GitHub Tiny URL
    # Usage: github_tinyurl <github url>
    github_tinyurl()
    {
        local url=$1
        curl -o- -i -s http://git.io -F "url=$url" | grep "Location" | awk '{print $2}'
    }
    
    # Opens a google-chrome browser and googles for the query
    # Usage: google <query>
    # eg: google shell scripting
    google()
    {
        google-chrome "https://www.google.com.au/search?q=$1&btnl=1"
    }

    # Copies the current terminal line
    # Bound to ALT+C
    copy_current_line()
    {
        local current_line="${READLINE_LINE:0:$READLINE_POINT}${CLIP}${READLINE_LINE:$READLINE_POINT}"
        echo -n "$current_line" | xclip
    }
    bind -m emacs -x '"\ec": copy_current_line'

    # Copies the last command executed 
    copy_last_command()
    {
        fc -ln -1 | sed 's/^ *//' | xclip                            # copies to middle-click-paste
        # fc -ln -1 | sed 's/^ *//' | xclip -selection clipboard     # copies to regular paste
    }
    
    # Displays the final text block from a file
    # Usage: display_final_block <file>
    # eg: display_final_block ~/.workstation
    function display_final_block()
    {
        local file="$1"
        local description="$2"
        echo -en "\n\n$description\n\n"
        
        local line
        tac "$file" | while read line
        do
            [[ "$line" ]] || break
            echo -en "\t$line\n"
        done | tac
    }
    
    # Describes a function
    # Usage: describe_function <function name>
    # eg: describe_function display_final_block
    function describe_function()
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
        
        echo -en "\n\t$function_name\n"
        
        let "line_number-=1"
        local line
        head -n "$line_number" "$file" | tac | while read line
        do
            [[ "$line" ]] || break
            echo -en "\t\t$line\n"
        done | tac
        
        let "line_number+=1"
        echo -en "\n\t\t$file +${line_number}\n"
    }

    # Describes a list of functions
    # Usage: describe_functions <function list> <list name>
    describe_functions()
    {
        function_list=$1
        function_list_name=$2
        echo -en "\n\n$function_list_name\n"
        echo "$function_list" | while read function_name
        do
            describe_function "$function_name"
        done
    }
    
    # Get list of misc functions defined
    [[ "$misc_function_list" ]] ||
        misc_function_list=$(grep -Fxv -f     \
            <(echo "$original_function_list") \
            <(compgen -A function))


## OTHER SCRIPTS ##
    
    # Source any scripts in the ~/.workstation.d directory
    [ -d ~/.workstation.d ] || mkdir ~/.workstation.d
    if [ "$(ls -A ~/.workstation.d)" ]
    then
        for script in ~/.workstation.d/*
        do
            source "$script"
        done
    fi
    
    # Get list of other functions defined
    [[ "$other_function_list" ]] ||
        other_function_list=$(grep -Fxv -f     \
            <(echo "$original_function_list $misc_function_list") \
            <(compgen -A function))

## WORKSTATION FUNCTIONS ##
    
    # Displays list of functions defined by ~/.workstation
    _workstation_help()
    {
        local help=''
        help+="$(describe_functions "$misc_function_list" "Misc functions:")"
        help+="$(describe_functions "$other_function_list" "Other functions:")"
        help+="$(describe_functions "$workstation_function_list" "Workstation functions:")"
        help+="$(display_final_block ~/.workstation "Notes:")"
        less -qf <(echo "$help")
    }
    
    # This is only executed when run with the wget command at the top of the script,
    # or when passing in the "setup" argument.
    # It is not run when auto-loaded by your profile.
    _workstation_setup()
    {    
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
            local git_user_name
            read git_user_name
            git config --global user.name "$git_user_name"
        fi
        
        if [ -z "$(git config --global user.email)" ]
        then
            echo -n "Git user email: "
            local git_user_email
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
        echo -en "see:\n\tworkstation help\n"
    }
    
    # Reloads bash
    _workstation_reload()
    {
        echo "reloading ~/.workstation"
        bash
        # source ~/.workstation
    }
    
    # Provides various helpful functions
    workstation()
    {
        # If no member function passed, show help
        if [ -z "$1" ]
        then
            workstation help
            return 0
        fi
                
        local member_function="$(printf "_%s_%s" "$FUNCNAME" "$1")"
        if [ "$(type -t "$member_function")" = "function" ]
        then
            $member_function
        else
            echo -en "$member_function function not defined\nsee:\n\rworkstation help\n"
            return 1
        fi
    }
    
    # Enable running workstation functions by either:
    #   - workstation <function name>
    #   - _workstation_<function name>
    #   - . ~/.workstation <function name>
    [ -n "$1" ] && workstation $1
    
    # Get list of workstation functions
    [[ "$workstation_function_list" ]] ||
        workstation_function_list=$(grep -Fxv -f     \
            <(echo "$original_function_list $misc_function_list $other_function_list") \
            <(compgen -A function))


## TODO ##

    # Autocompletions:
    #   http://tldp.org/LDP/abs/html/tabexpansion.html
    #   _ssh_hosts=$(grep "Host " ~/.ssh/config | awk '{print $2}')
    #   complete -W "$_ssh_hosts" myfunction
    # Help / Documentation - Reflection?
    #   http://stackoverflow.com/questions/2630812/
    # Login Info (git user)
    # Push / Pull Script
    # Generate Key


## NOTES ##

    # Bash Manual:        http://linux.die.net/man/1/bash
    # Sublime Setup:      https://gist.github.com/deanrather/2885590
    # Keyboard Shortcuts: https://gist.github.com/deanrather/2915320
    # Using Vim:          https://gist.github.com/deanrather/7310797
    # Using Git:          https://gist.github.com/deanrather/5572701
    # Using VimDiff:      https://gist.github.com/mattratleph/4026987
