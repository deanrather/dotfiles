#!/bin/bash
# dotfiles.sh
# Configures the terminal, prompt, etc.

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


# Displays list of functions defined by ~/dotfiles/dotfiles.sh
_dotfiles_help()
{
    local help=''
    help+="$(describe_functions "$dotfiles_function_list" "dotfiles functions:")"
    help+="$(describe_functions "$misc_function_list" "Misc functions:")"
    help+="$(describe_functions "$other_function_list" "Other functions:")"
    less -qf <(echo "$help")
}

_dotfiles_version()
{
    local git_dir
    git_dir=~/dotfiles/.git
    git --git-dir="$git_dir" log -1 --pretty="%ci (%cr) - %s"
}

_dotfiles_debug()
{
	bash -e ~/dotfiles/dotfiles.sh
}

# Reloads bash
_dotfiles_reload()
{
    # clear
    # unset other_function_list
    # unset original_function_list
    # unset misc_function_list
    # unset dotfiles_function_list
    source ~/.profile
}

# Updates dotfiles from github
_dotfiles_pull()
{
    cd ~/dotfiles
    git pull
    dotfiles reload
    cd -
}

# push dotfiles to github
_dotfiles_push()
{
    cd ~/dotfiles
    git commit -am "updated with dotfiles push"
    if ! git remote -v | grep origin | grep "git@"
    then
	    if ! ssh -T git@github.com 2>&1 | grep "successfully authenticated"
    	then
    		echo "ERROR: no permission to push"
    		exit 1
	    fi
	    new_origin="$(git remote -v | grep origin | grep push | sed 's|https://github.com/|git@github.com:|' | cut -f 2 | cut -d ' ' -f 1)"
	    git remote rm origin
	    git remote add origin "$new_origin"
	fi
    git push
    git status
    cd -
}

_dotfiles_hotkey()
{
    echo 'hotkey pressed' >> /tmp/dotfiles-hotkey.log
}

# Provides various helpful functions
dotfiles()
{
    # If no member function passed, show help
    if [ -z "$1" ]
    then
        dotfiles help
        return 0
    fi

    local member_function="$(printf "_%s_%s" "$FUNCNAME" "$1")"
    if [ "$(type -t "$member_function")" = "function" ]
    then
        $member_function
    else
        echo -en "Undefined function: $member_function\nsee:\n\tdotfiles help\n\n"
        return 1
    fi
}

# Enable running dotfiles functions by either:
#   - dotfiles <function name>
#   - _dotfiles_<function name>
#   - . ~/.dotfiles <function name>
[ -n "$1" ] && dotfiles $1

# Get list of dotfiles functions
[[ "$dotfiles_function_list" ]] ||
    dotfiles_function_list=$(grep -Fxv -f \
        <(echo -e "$original_function_list\n$misc_function_list\n$other_function_list") \
        <(compgen -A function))

# Provide autocompletions
dotfiles_function_names="$(echo $dotfiles_function_list | sed 's/_dotfiles_//g')"
dotfiles_function_names="$(echo $dotfiles_function_names | sed 's/ dotfiles//g')"
complete -W "$dotfiles_function_names" dotfiles

# Ensure SSH agent is running
# eval $(ssh-agent) > /dev/null 2>&1 &
# ssh-add ~/.ssh/*
