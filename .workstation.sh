#!/bin/bash
# Workstation Configurator

    # To setup this script, run:
    #
    #   wget -O ~/.workstation git.io/workstation && . ~/.workstation setup
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
    package_list="git ssh tig vim tree xclip xdotool screen"

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
    # https://wiki.archlinux.org/index.php/Color_Bash_Prompt
    set_prompt()
    {
        local previous_exit_code=$?
        local blue='\[\e[01;34m\]'
        local red='\[\e[01;31m\]'
        local green='\[\e[01;32m\]'
        local white='\[\e[00m\]'
        local cross='\342\234\227'
        local tick='\342\234\223'
        local git_branch="$(git branch 2> /dev/null | grep '*' | awk '{print $NF}' | sed 's/)//g')"
        PS1=""

        # Tick or a cross depending on the previous exit code
        [[ $previous_exit_code == 0 ]] && PS1+="$green$tick" || PS1+="$red$cross"
        # PS1+="$white|"
        PS1+=" "

        # Host, or user@host depending on user
        [[ $EUID == 0 ]] && PS1+="$red\\h" || PS1+="$green\\u@\\h"
        PS1+="$white:"

        # Working directory
        PS1+="$blue\\w"

        # Green or red git branch, depending on dirty
        if [ -n "$git_branch" ]
        then
            # PS1+="$white|"
            PS1+=" "
            [[ -z $(git status --porcelain) ]] && PS1+="$green" || PS1+="$red"
            PS1+="$git_branch"
        fi

        # Print the special dollar sign, and a space
        PS1+="$white\\\$ "
    }
    PROMPT_COMMAND='set_prompt'

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
    
    # Run a program in the background
    # Usage: run_in_background
    run_in_background()
    {
        $@ > /dev/null 2>&1 &
        echo "Job running in background with pid: $!"
    }

    # Shortens a GitHub URL
    # Usage: github_shortenurl <github url> [<code>]
    github_shortenurl()
    {
        local url="$(echo $1 | sed 's/githubusercontent/github/g')"
        local code=$2
        curl -o- -i -s http://git.io -F "url=$url" -F "code=$code" | grep "Location" | awk '{print $2}'
        return $?
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

    # View active network connections
    view_network()
    {
        lsof -i
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

        # tmp hax
        function_name="$(echo $function_name | sed 's/_workstation_/workstation /g')"
                
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

    # Get list of misc functions defined
    [[ "$misc_function_list" ]] ||
        misc_function_list=$(grep -Fxv -f \
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
    unset script

    # Get list of other functions defined
    [[ "$other_function_list" ]] ||
        other_function_list=$(grep -Fxv -f \
            <(echo -e "$original_function_list\n$misc_function_list") \
            <(compgen -A function))

## WORKSTATION FUNCTIONS ##

    # Displays list of functions defined by ~/.workstation
    _workstation_help()
    {
        local help=''
        help+="$(describe_functions "$workstation_function_list" "Workstation functions:")"
        help+="$(describe_functions "$misc_function_list" "Misc functions:")"
        help+="$(describe_functions "$other_function_list" "Other functions:")"
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
            unset package_list
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

        echo "Configuring Screen"
        touch ~/.screenrc
        grep -q "vbell"   ~/.screenrc || echo "vbell off"  >> ~/.screenrc

        echo "Configuring Profile"
        grep -q "~/.workstation" ~/.bashrc || echo -e "\n[ -f ~/.workstation ] && . ~/.workstation" >> ~/.bashrc

        echo "$(git config --global user.name) configured"
        echo -en "see:\n\tworkstation help\n\n"
    }

    # Reloads bash
    _workstation_reload()
    {
        clear
        # unset other_function_list
        # unset original_function_list
        # unset misc_function_list
        # unset workstation_function_list
        source ~/.workstation
    }
       
    # Updates workstation from github
    _workstation_pull()
    {
        if [ -d ~/.workstation.git ]
        then
            cd ~/.workstation.git
            git pull
            cd -
        else
            # TODO: dynamic url
            # Check keys ok before mving!
            git clone git@gist.github.com:/5719199.git ~/.workstation.git
            mv ~/.workstation ~/.workstation.bak
            ln -s ~/.workstation.git/.workstation.sh ~/.workstation
        fi
        workstation reload
    }
    
    # push workstation to github
    _workstation_push()
    {
        if [ -d ~/.workstation.git ]
        then
            cd ~/.workstation.git
            git commit -am "updated with workstation push"
            git push
            cd -
        else
            echo "no local workstation repo, use 'workstation pull' first"
        fi
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
            echo -en "Undefined function: $member_function\nsee:\n\tworkstation help\n\n"
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
        workstation_function_list=$(grep -Fxv -f \
            <(echo -e "$original_function_list\n$misc_function_list\n$other_function_list") \
            <(compgen -A function))

    # Provide autocompletions
    workstation_function_names="$(echo $workstation_function_list | sed 's/_workstation_//g')"
    workstation_function_names="$(echo $workstation_function_names | sed 's/ workstation//g')"
    complete -W "$workstation_function_names" workstation
    
    # Ensure SSH agent is running
    # eval $(ssh-agent) > /dev/null 2>&1 &
    # ssh-add ~/.ssh/*
    
## TODO ##

    # SSH Agent only when required..
    # Fix the repeat function
    # Generate Key
    # http://ithaca.arpinum.org/2013/01/02/git-prompt.html
    # Disk / RAM / CPU Alerts on login


## NOTES ##

    # Bash Manual:        http://linux.die.net/man/1/bash
    # Dev Setup:          https://gist.github.com/deanrather/4327301
    # Sublime Setup:      https://gist.github.com/deanrather/2885590
    # Keyboard Shortcuts: https://gist.github.com/deanrather/2915320
    # Using Vim:          https://gist.github.com/deanrather/7310797
    # Using Git:          https://gist.github.com/deanrather/5572701
    # Using VimDiff:      https://gist.github.com/mattratleph/4026987
