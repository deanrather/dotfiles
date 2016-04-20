#!/bin/bash
# prompt.sh
# 
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

# Set the bash prompt
PROMPT_COMMAND='set_prompt'
