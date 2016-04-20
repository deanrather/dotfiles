#!/bin/bash
# Workstation Configurator

# To setup this script, run:
#
#   ~/dotfiles/workstation.sh setup
#
# This achieves a few things:
# - Installation & Setup of helpful programs
# - Adds `workstation.sh` to your `~/.bashrc`, so that it autoloads on each terminal.
# - Provides `~/dotfiles-autoload` directory for auto-loading your own scripts
#
# For help, run:
#
#   workstation help


## CONFIGURATION ##

# Configure History to automatically save
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Configure history to save with timestamp
export HISTTIMEFORMAT="%Y-%m-%d %T "


# Generating Help
# This saves a list of defined functions to the variable
# It will be compared to a list we'll make futher down,
# so we can know which functions were defined.
[[ "$original_function_list" ]] || original_function_list=$(compgen -A function)


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

# Source any scripts in the ~/dotfiles-autoload directory
[ -d ~/dotfiles-autoload ] || mkdir ~/dotfiles-autoload
if [ "$(ls -A ~/dotfiles-autoload)" ]
then
    for script in ~/dotfiles-autoload/*
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

# Displays list of functions defined by ~/dotfiles/workstation.sh
_workstation_help()
{
    local help=''
    help+="$(describe_functions "$workstation_function_list" "Workstation functions:")"
    help+="$(describe_functions "$misc_function_list" "Misc functions:")"
    help+="$(describe_functions "$other_function_list" "Other functions:")"
    help+="$(display_final_block ~/dotfiles/workstation.sh "Notes:")"
    less -qf <(echo "$help")
}

_workstation_debug()
{
	bash -e ~/dotfiles/workstation.sh
}

# This is only executed when run with the wget command at the top of the script,
# or when passing in the "setup" argument.
# It is not run when auto-loaded by your profile.
_workstation_setup()
{
    # Install packages
    local packages
    packages="$(cat ~/dotfiles/packages.txt)"
    if apt-cache policy $packages | grep 'Installed: (none)' > /dev/null
    then
        echo "Installing:"
        echo "$packages"
        sudo apt-get update
        sudo apt-get install -y $packages
    fi

    # Configure Git
    if [ -z "$(git config --global user.name)" ]
    then
        echo -n "Git user name (The name to appear on your commits): "
        local git_user_name
        read git_user_name
        git config --global user.name "$git_user_name"
    fi

    if [ -z "$(git config --global user.email)" ]
    then
        echo -n "Git user email (The email to appear on your commits): "
        local git_user_email
        read git_user_email
        git config --global user.email "$git_user_email"
    fi
    git config --global include.path ~/dotfiles/git.conf
    

    # Symlink config files
    echo "Symlinking config files"
    source ~/dotfiles/functions.sh
    backup_remove ~/.tigrc      && ln -s ~/dotfiles/tig.conf  ~/.tigrc
    backup_remove ~/.vimrc      && ln -s ~/dotfiles/vim.conf  ~/.vimrc
    backup_remove ~/.tmux.conf  && ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
    
    # Setup & symlink autoloads
    echo "Making ~/.dotfiles-autolod dir, symlinking aliases and functions"
    [ -d ~/dotfiles-autoload ] || mkdir ~/dotfiles-autoload
    [ -e ~/dotfiles-autoload/functions.sh ] || ln -s ~/dotfiles/functions.sh ~/dotfiles-autoload/functions.sh
    [ -e ~/dotfiles-autoload/aliases.sh ]   || ln -s ~/dotfiles/aliases.sh   ~/dotfiles-autoload/aliases.sh
    [ -e ~/dotfiles-autoload/prompt.sh ]   || ln -s ~/dotfiles/prompt.sh   ~/dotfiles-autoload/prompt.sh
    [ -e ~/dotfiles-autoload/banner.sh ]   || ln -s ~/dotfiles/banner.sh   ~/dotfiles-autoload/banner.sh

    # Setup workstation to autoload
    echo "Configuring Profile"
    grep -q "workstation.sh" ~/.bashrc || echo -e "\n[ -f ~/dotfiles/workstation.sh ] && . ~/dotfiles/workstation.sh" >> ~/.bashrc

    # Done!
    echo "$(git config --global user.name) configured"
    echo -en "see:\n\tworkstation help\n\n"
}

# Reloads bash
_workstation_reload()
{
    # clear
    # unset other_function_list
    # unset original_function_list
    # unset misc_function_list
    # unset workstation_function_list
    source ~/.profile
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

# Generate Key
# SSH Agent
# Fix the repeat function
# http://ithaca.arpinum.org/2013/01/02/git-prompt.html
# Disk / RAM / CPU Alerts on login
# Change all the helper functions to use gist and have the code separate
# Separate Desktop vs Server programs


## NOTES ##

# Bash Manual:        http://linux.die.net/man/1/bash
# Dev Setup:          https://gist.github.com/deanrather/4327301
# Sublime Setup:      https://gist.github.com/deanrather/2885590
# Keyboard Shortcuts: https://gist.github.com/deanrather/2915320
# Using Vim:          https://gist.github.com/deanrather/7310797
# Using Git:          https://gist.github.com/deanrather/5572701
# Using VimDiff:      https://gist.github.com/mattratleph/4026987
