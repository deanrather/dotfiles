#!/bin/bash
# ~/.tmux-aliases.lib.sh
# 
# Dean's tmux aliases library
#
# 
# Installation:
#
#   This snippet will download the aliases library and source it into your ~/.bashrc:
# 
#     wget -O ~/.tmux-aliases.lib.sh https://raw.githubusercontent.com/deanrather/dotfiles/master/.tmux-aliases.lib.sh && grep '^source ~/.tmux-aliases.lib.sh' ~/.bashrc || echo 'source ~/.tmux-aliases.lib.sh' >> ~/.bashrc && source ~/.bashrc
#
#
# Summary:
#
# - Adds some aliases for using tmux
# - adds autocompletions for tmux
# 
# 
# See Also:
# 
#   Dean's Tmux Config - https://raw.githubusercontent.com/deanrather/dotfiles/master/.tmux.conf
# 

alias tns="tmux new-session -s"  # requires session-name
alias tls="tmux list-sessions"
alias tas="tmux attach -t"       # requires session-name
alias tds="tmux detach-client"   # detach this client from session
alias tks="tmux kill-session -t" # requires session-name
alias tmux-help="grep -Pzo '# Summary(.|\n)*\n# Config' ~/.tmux.conf | head -n -2 | sed 's/^#//g' | sed 's/^ //g'"


# Completions
function _autocomplete_tmux_sessions() {
    options="$(tmux list-sessions | cut -d ':' -f 1)"

    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
}

complete -F _autocomplete_tmux_sessions tas
complete -F _autocomplete_tmux_sessions tks
